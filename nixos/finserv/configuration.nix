# finserv/configuration.nix

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/server-conf.nix
    ../shared/shared-conf.nix
    ../../secrets/finserv-secrets.nix
  ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking = {
    hostName = "finserv";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3030 4040 9735 9736 3001 60845 ];
    };
  };

  ### nix-bitcoin section

  # Automatically generate all secrets required by services.
  # The secrets are stored in /etc/nix-bitcoin-secrets
  nix-bitcoin.generateSecrets = true;

  # Enable some services.
  # See ../configuration.nix for all available features.
  services = {
    backups.enable = true; # backs up data to /var/lib/localBackups
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
      enable = false; # Enable clightning, a Lightning Network implementation in C.
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
      enable = false;
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
      # extraConfig = ''
      #   admin = 0.0.0.0:9999
      # '';
    };
    liquidd = {
      enable = true;
    };
    lnbits = {
      enable = true;
      host = "0.0.0.0";
      env = {
        # If setting these values declaritively doesn't work, set
        # them manually in the GUI under Server > Funding Sources
        LNBITS_BACKEND_WALLET_CLASS = "LndWallet";
        LND_GRPC_ENDPOINT = "127.0.0.1";
        LND_GRPC_PORT = "10009";
        LND_GRPC_CERT = "/etc/nix-bitcoin-secrets/lnd-cert";
        LND_GRPC_MACAROON = "/var/lib/lnd/chain/bitcoin/mainnet/admin.macaroon";
      };
    };
    lnd = {
      enable = true;
      lndconnect.enable = true;
      # certificate.extraIPs = [ "<this-is-secret>" ]; # look in finserv-secrets.nix
      extraConfig = ''
        protocol.simple-taproot-chans=true
        alias=Antares
        # This next line is a workaround for a bug where the health check keeps failing and
        # then LND shuts down. See https://github.com/lightningnetwork/lnd/issues/4669
        healthcheck.chainbackend.attempts=0
        # these next three options are required for LNDK (for bolt12 offers)
        protocol.custom-message=513
        protocol.custom-nodeann=39
        protocol.custom-init=39
      '';
      # LNDK is a program that runs alongside LND and provides BOLT12 functionality, although
      # as of 2024-09-26 it cannot receive BOLT12 payments, it can only send them. Also,
      # there currently is a bug in the nixpkgs version of LND that is missing the 
      # build flag for peersrpc, which LNDK requires. Commit 00f961d fixes it, but until
      # that commit makes it into unstable, the following override is a workaround:
      # package = config.nix-bitcoin.pkgs.lnd.overrideAttrs (old: {
      #   tags = old.tags ++ [ "peersrpc" ];
      # });
      rpcAddress = "0.0.0.0";
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
    defaultSopsFile = ../../secrets/sops-secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "borg/passphrase" = { };
      "borg/repos/finserv-cln" = { };
      "borg/ssh-private-key" = { };
      "wireguard/finserv/wg-conf" = { };
      "wireguard/punk/ip" = { };
    };
    # templates = {
    #   "your-config-with-secret-file.toml".content = ''
    #     password = "${config.sops.placeholder."wireguard/punk/ip"}"
    #   '';
    # };
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
    lnd-connect-to-peers = {
      serviceConfig = {
        Type = "oneshot";
        User = "lnd";
        ExecStart = [
          # ACINQ
          "-${pkgs.lnd}/bin/lncli --tlscertpath=/etc/nix-bitcoin-secrets/lnd-cert --macaroonpath /var/lib/lnd/chain/bitcoin/mainnet/admin.macaroon connect --perm 03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f@3.33.236.230:9735 2> /dev/null"
          # WalletOfSatoshi
          "-${pkgs.lnd}/bin/lncli --tlscertpath=/etc/nix-bitcoin-secrets/lnd-cert --macaroonpath /var/lib/lnd/chain/bitcoin/mainnet/admin.macaroon connect --perm 035e4ff418fc8b5554c5d9eea66396c227bd429a3251c8cbc711002ba215bfc226@170.75.163.209:9735 2> /dev/null"
          # Boltz
          "-${pkgs.lnd}/bin/lncli --tlscertpath=/etc/nix-bitcoin-secrets/lnd-cert --macaroonpath /var/lib/lnd/chain/bitcoin/mainnet/admin.macaroon connect --perm 026165850492521f4ac8abd9bd8088123446d126f648ca35e60f88177dc149ceb2@45.86.229.190:9735 2> /dev/null"
          # Kraken
          "-${pkgs.lnd}/bin/lncli --tlscertpath=/etc/nix-bitcoin-secrets/lnd-cert --macaroonpath /var/lib/lnd/chain/bitcoin/mainnet/admin.macaroon connect --perm 02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69@52.13.118.208:9735 2> /dev/null"
        ];
      };
    };
    lnd = {
      postStart = "chmod g+rx ${config.services.lnd.dataDir}/chain{,/bitcoin{,/${config.services.bitcoind.network}}}";
    };
  };
  systemd.timers = {
    lnd-connect-to-peers = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* *:00:00";
        Unit = "lnd-connect-to-peers.service";
      };
    };
  };
  users.users.lnbits = {
    extraGroups = [ "lnd" ];
  };
}

