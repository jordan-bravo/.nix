{ config, inputs, pkgs, ... }:

### Home Wi-Fi: Tailscale exit-node LAN access + access-point pin.
#
# On the home Wi-Fi:
#   - Tailscale exit-node LAN access on (router and home devices reachable);
#     off on every other network.
#   - The saved Wi-Fi profile is pinned to one access point. The home
#     gateway runs two 5 GHz radios under one name with near-equal signal,
#     and without the pin the laptop roamed between them every ~1 min
#     (255 roams on 2026-11-23). The gateway has no setting to fix this.
#
# The home network name and access-point address are private, so they live
# encrypted in secrets/sops-secrets.yaml (tux/home-wifi/{ssid,bssid}), not
# here. Edit with: sops secrets/sops-secrets.yaml
#
#   Check:  tailscale debug prefs | grep LANAccess
#   Log:    journalctl -t home-wifi
#   Unpin:  nmcli connection modify <name> 802-11-wireless.bssid ""
#           (and remove tux/home-wifi/bssid, or it is re-applied on connect)
let
  ssidFile = config.sops.secrets."tux/home-wifi/ssid".path;
  bssidFile = config.sops.secrets."tux/home-wifi/bssid".path;
  nmcli = "${pkgs.networkmanager}/bin/nmcli";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.keyFile = "/home/jordan/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/sops-secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets."tux/home-wifi/ssid" = { };
    secrets."tux/home-wifi/bssid" = { };
  };

  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "home-wifi" ''
        # $1 = interface, $2 = action; NetworkManager sets CONNECTION_UUID.
        case "$2" in up|down|connectivity-change) ;; *) exit 0 ;; esac
        log() { ${pkgs.util-linux}/bin/logger -t home-wifi "$*"; }

        home_ssid=$(${pkgs.coreutils}/bin/cat ${ssidFile} 2>/dev/null)
        ssid=$(${nmcli} -t -f ACTIVE,SSID dev wifi \
          | ${pkgs.gnugrep}/bin/grep -m1 '^yes:' | ${pkgs.coreutils}/bin/cut -d: -f2-)

        if [ -n "$home_ssid" ] && [ "$ssid" = "$home_ssid" ]; then
          allow=true
        else
          allow=false
        fi

        ${config.services.tailscale.package}/bin/tailscale set \
          --exit-node-allow-lan-access="$allow" 2>&1 | log
        log "$1 $2: home=$allow -> exit-node LAN access $allow"

        # Pin the home profile to one access point if it isn't already.
        if [ "$allow" = true ] && [ "$2" = up ] && [ -n "''${CONNECTION_UUID:-}" ]; then
          want=$(${pkgs.coreutils}/bin/tr -d ' \n' < ${bssidFile} | ${pkgs.coreutils}/bin/tr a-f A-F)
          have=$(${nmcli} -g 802-11-wireless.bssid connection show uuid "$CONNECTION_UUID" \
            | ${pkgs.coreutils}/bin/tr -d '\\' | ${pkgs.coreutils}/bin/tr a-f A-F)
          if [ -n "$want" ] && [ "$have" != "$want" ]; then
            ${nmcli} connection modify uuid "$CONNECTION_UUID" 802-11-wireless.bssid "$want" \
              && log "pinned home profile to its access point (applies from next connect)"
          fi
        fi
      '';
    }
  ];
}
