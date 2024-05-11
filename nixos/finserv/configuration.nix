# finserv/configuration.nix

{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/server-conf.nix
    inputs.sops-nix.nixosModules.sops
  ];

  networking = {
    hostName = "finserv";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 50001 50002 ];
      allowedUDPPorts = [ 50001 50002 ];
    };
  };

  ### nix-bitcoin section

  # Automatically generate all secrets required by services.
  # The secrets are stored in /etc/nix-bitcoin-secrets
  nix-bitcoin.generateSecrets = true;

  # Enable some services.
  # See ../configuration.nix for all available features.
  services = {
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
    # caddy = {
    #   enable = false;
    #   # logFormat = ''
    #   #   level DEBUG
    #   # '';
    #   package = pkgs.callPackage ../shared/caddy.nix {
    #     plugins = [
    #       "github.com/caddy-dns/cloudflare"
    #     ];
    #   };
    #   virtualHosts."fulcrum.finserv.top".extraConfig = ''
    #     reverse_proxy localhost:50002
    #     tls {
    #       dns cloudflare {env.CF_API_TOKEN}
    #     }
    #   '';
    # };
    ### CLIGHTNING
    clightning = {
      enable = true; # Enable clightning, a Lightning Network implementation in C.
      # == Plugins
      # See ../README.md (Features → clightning) for the list of available plugins.
      plugins.clboss.enable = false;
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
        onion = true;
      };
    };
    fulcrum = {
      enable = true;
      # To generate a cert, run the command: sudo tailscale cert
      # Then change the owner of the crt and key files to fulcrum: chown fulcrum:fulcrum
      # Finally, copy or move them to the directory below for cert and key
      extraConfig = ''
        ssl = 0.0.0.0:50002
        admin = 9999
        cert = /var/lib/fulcrum/finserv.snowy-hops.ts.net.crt
        key = /var/lib/fulcrum/finserv.snowy-hops.ts.net.key
      '';
    };
    mempool = {
      enable = false;
      electrumServer = "fulcrum";
      frontend = {
        enable = true;
        # nginxConfig = {};
      };
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

  # sops = {
  #   age.keyFile = "/home/main/.config/sops/age/keys.txt";
  #   defaultSopsFile = ../../secrets/secrets.yaml;
  #   defaultSopsFormat = "yaml";
  #   secrets = {
  #     "caddy/cloudflare/api-token" = {
  #       owner = "caddy";
  #     };
  #   };
  # };

  systemd.services = {
    # caddy = {
    #   serviceConfig = {
    #     AmbientCapabilities = "cap_net_bind_service";
    #     Environment = ''
    #       CF_API_TOKEN=${config.sops.secrets."caddy/cloudflare/api-token".path}
    #     '';
    #   };
    # };
  };
}

