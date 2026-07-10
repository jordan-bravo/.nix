# Declarative flatpak management via nix-flatpak (home-manager module).
# The nix-flatpak module itself is injected in flake.nix:
# home-manager.sharedModules for NixOS hosts, modules list for standalone hosts.
# Per-host apps are declared in each host's home.nix via services.flatpak.packages;
# do not add apps here.
{ pkgs, ... }:
let
  # The KStyle.Adwaita runtime extension provides the Adwaita/Adwaita-Dark Qt
  # styles. It is branch-locked to the KDE runtime version and marked
  # no-autodownload upstream, so `flatpak update` never pulls new branches of
  # it. This script installs the matching extension branch for every installed
  # KDE runtime branch; it runs after each nix-flatpak install/update pass.
  kstyleAdwaitaSync = pkgs.writeShellScript "flatpak-kstyle-adwaita-sync" ''
    set -eu
    flatpak=${pkgs.flatpak}/bin/flatpak
    $flatpak --user list --runtime --columns=application,branch \
      | ${pkgs.gawk}/bin/awk '$1 == "org.kde.Platform" { print $2 }' \
      | ${pkgs.coreutils}/bin/sort -u \
      | while read -r branch; do
          ref="org.kde.KStyle.Adwaita//$branch"
          if ! $flatpak --user info "$ref" >/dev/null 2>&1; then
            echo "Installing $ref"
            $flatpak --user install --noninteractive flathub "$ref" \
              || echo "warning: could not install $ref (no such branch on flathub yet?)" >&2
          fi
        done
  '';
in
{
  services.flatpak = {
    enable = true;
    # Flathub is the only declared remote. Remotes added imperatively are left
    # alone unless uninstallUnmanaged = true (which would also uninstall any
    # apps not declared in services.flatpak.packages — enable per-host only
    # after declaring that host's apps).
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    # Adwaita Dark for all Qt flatpaks. The gnome platform theme supplies no
    # palette, so Qt falls back to the Adwaita-Dark style's own dark palette;
    # the default gtk3 platform theme would inject a light palette and produce
    # a mixed light/dark UI. GTK flatpaks follow the desktop's dark
    # color-scheme via the settings portal and need no override.
    overrides.global.Environment = {
      QT_QPA_PLATFORMTHEME = "gnome";
      QT_STYLE_OVERRIDE = "Adwaita-Dark";
    };
  };

  # Run the KStyle sync after nix-flatpak's install pass (triggered at
  # activation) and after its daily update timer, so new KDE runtime branches
  # get their Adwaita style extension without manual config bumps.
  systemd.user.services = {
    flatpak-kstyle-adwaita-sync = {
      Unit = {
        Description = "Install KStyle.Adwaita for each installed KDE runtime branch";
        After = [
          "flatpak-managed-install.service"
          "flatpak-managed-install-timer.service"
        ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${kstyleAdwaitaSync}";
      };
    };
    flatpak-managed-install.Unit.Wants = [ "flatpak-kstyle-adwaita-sync.service" ];
    flatpak-managed-install-timer.Unit.Wants = [ "flatpak-kstyle-adwaita-sync.service" ];
  };
}
