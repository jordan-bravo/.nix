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
  ];

  networking = {
    hostName = "finserv";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3030 4040 9735 9736 3001 60845 ];
      # allowedUDPPorts = [ 51820 ];
    };
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
        disable-mpp
      '';
      replication = {
        enable = true;
        local.directory = "/var/backup/clightning";
      };
      port = 9736;
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
    electrs = {
      enable = false;
      address = "0.0.0.0";
    };
    fulcrum = {
      enable = true;
      address = "0.0.0.0";
      # To generate a Tailscale SSL cert, run the command: sudo tailscale cert
      # Then change the owner of the crt and key files to fulcrum: chown fulcrum:fulcrum
      # Finally, copy or move them to the directory below for cert and key
      # extraConfig = ''
      #   # ssl = 0.0.0.0:50002
      #   tcp = 0.0.0.0:50001
      #   admin = 9999
      #   # cert = ${config.sops.secrets."ssl/xav-icu/cloudflare/cert".path}
      #   # key = ${config.sops.secrets."ssl/xav-icu/cloudflare/key".path}
      # '';
      extraConfig = ''
        admin = 0.0.0.0:9999
      '';
    };
    liquidd = {
      enable = true;
    };
    lnd = {
      enable = true;
      lndconnect.enable = true;
      extraConfig = ''
        protocol.simple-taproot-chans=true
      '';
    };
    mempool = {
      enable = true;
      electrumServer = "fulcrum";
      frontend = {
        enable = true;
        address = "0.0.0.0";
        # nginxConfig = {};
      };
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
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
  # networking.wg-quick.interfaces = {
  #   wg0.configFile = "${config.sops.secrets."wireguard/finserv/wg-conf".path}";
  # };

  sops = {
    age.keyFile = "/home/main/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "borg/passphrase" = { };
      "borg/repos/finserv-cln" = { };
      "borg/ssh-private-key" = { };
      "wireguard/finserv/wg-conf" = { };
      "wireguard/punk/ip" = { };
    };
  };
  systemd.services = {
    listmaker-node-3030 = {
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.nodejs_22}/bin/node /home/main/apps/listmaker-node-3030/build/index.js";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };
    listmaker-node-4040 = {
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.nodejs_22}/bin/node /home/main/apps/listmaker-node-4040/build/index.js";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}

