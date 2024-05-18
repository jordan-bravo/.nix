# finserv/configuration.nix

{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/server-conf.nix
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
    wget
  ];

  networking = {
    hostName = "finserv";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 50001 50002 3030 4040 9735 3001 ];
      allowedUDPPorts = [ 51820 ];
    };
  };

  networking.networkmanager = {
    enable = true;
    # dns = "systemd-resolved"; # "default" | "dnsmasq" | "systemd-resolved" | "none"
  };
  # networking.nameservers = [
  #   "9.9.9.9"
  #   "149.112.112.112"
  #   # "194.242.2.2"
  #   # "2a07:e340::2"
  # ];

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  ### nix-bitcoin section

  # Automatically generate all secrets required by services.
  # The secrets are stored in /etc/nix-bitcoin-secrets
  nix-bitcoin.generateSecrets = true;

  # Enable some services.
  # See ../configuration.nix for all available features.
  services = {
    borgbackup = {
      jobs = {
        finserv-cln = {
          compression = "auto,lzma";
          encryption = {
            mode = "repokey-blake2";
            passCommand = "cat ${config.sops.secrets."borg/passphrase".path}";
          };
          environment = {
            BORG_RSH = "ssh -i ${config.sops.secrets."borg/ssh-private-key".path}";
          };
          paths = "/var/backup/clightning";
          preHook = ''
            export BORG_REPO=$(cat ${config.sops.secrets."borg/repos/finserv-cln".path})
          '';
          repo = "$BORG_REPO";
          startAt = "*-*-* 01:30:00";
          # startAt = "*-*-* *:*:*";
        };
      };
    };
    bitcoind = {
      enable = true;
      extraConfig = ''
        onlynet=onion
      '';
      listen = true;
      tor = {
        proxy = lib.mkDefault true;
        enforce = lib.mkDefault true;
      };
      txindex = true;
    };
    ### CLIGHTNING
    clightning = {
      enable = true; # Enable clightning, a Lightning Network implementation in C.
      # address = "82.180.160.3";
      # == Plugins
      # See ../README.md (Features → clightning) for the list of available plugins.
      extraConfig = ''
        experimental-onion-messages
        experimental-offers
        experimental-dual-fund
      '';
      replication = {
        enable = true;
        local.directory = "/var/backup/clightning";
      };
    };
    # == REST server
    # Set this to create a clightning REST onion service.
    # This also adds binary `lndconnect-clightning` to the system environment.
    # This binary creates QR codes or URLs for connecting applications to clightning
    # via the REST onion service.
    # You can also connect via WireGuard instead of Tor.
    # See ../docs/services.md for details.
    clightning-rest = {
      enable = true;
      lndconnect = {
        enable = true;
        onion = false;
      };
    };
    fulcrum = {
      enable = true;
      # To generate a Tailscale SSL cert, run the command: sudo tailscale cert
      # Then change the owner of the crt and key files to fulcrum: chown fulcrum:fulcrum
      # Finally, copy or move them to the directory below for cert and key
      extraConfig = ''
        ssl = 0.0.0.0:50002
        admin = 9999
        cert = ${config.sops.secrets."ssl/xav-icu/cloudflare/cert".path}
        key = ${config.sops.secrets."ssl/xav-icu/cloudflare/key".path}
      '';
    };
    mempool = {
      enable = false;
      electrumServer = "fulcrum";
      frontend = {
        enable = false;
        # nginxConfig = {};
      };
    };
    tailscale.enable = true;
    tor = {
      enable = true;
      client.enable = true;
    };
  };

  nix-bitcoin = {
    onionServices = {
      bitcoind.enable = lib.mkDefault true;
      # Set this to create an onion service by which clightning can accept incoming connections
      # via Tor.
      # The onion service is automatically announced to peers.
      clightning.public = true;
    };
    # When using nix-bitcoin as part of a larger NixOS configuration, set the following to enable
    # interactive access to nix-bitcoin features (like bitcoin-cli) for your system's main user
    operator = {
      enable = true;
      name = "main";
    };
  };

  # If you use a custom nixpkgs version for evaluating your system
  # (instead of `nix-bitcoin.inputs.nixpkgs` like in this example),
  # consider setting `useVersionLockedPkgs = true` to use the exact pkgs
  # versions for nix-bitcoin services that are tested by nix-bitcoin.
  # The downsides are increased evaluation times and increased system
  # closure size.
  #
  nix-bitcoin.useVersionLockedPkgs = true;

  # WireGuard
  networking.wg-quick.interfaces = {
    wg0.configFile = "${config.sops.secrets."wireguard/finserv/wg-conf".path}";
  };

  sops = {
    age.keyFile = "/home/main/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "borg/passphrase" = { };
      "borg/repos/finserv-cln" = { };
      "borg/ssh-private-key" = { };
      "ssl/xav-icu/cloudflare/cert" = { };
      "ssl/xav-icu/cloudflare/key" = { };
      "wireguard/finserv/private-key" = { };
      "wireguard/finserv/wg-conf" = { };
      "wireguard/punk/ip" = { };
    };
  };
}

