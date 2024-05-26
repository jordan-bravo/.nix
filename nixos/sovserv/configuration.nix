# sovserv/configuration.nix

{ config, inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  networking.hostName = "sovserv";

  services = {
    borgbackup = {
      jobs = {
        sovserv-nextcloud = {
          compression = "auto,lzma";
          encryption = {
            mode = "repokey-blake2";
            passCommand = "cat ${config.sops.secrets."borg/passphrase".path}";
          };
          environment = {
            BORG_RSH = "ssh -i ${config.sops.secrets."borg/ssh-private-key".path}";
          };
          paths = "/var/lib/nextcloud";
          preHook = ''
            export BORG_REPO=$(cat ${config.sops.secrets."borg/repos/sovserv-nextcloud".path})
          '';
          repo = "$BORG_REPO";
          startAt = "*-*-* 01:30:00";
        };
        sovserv-postgresql = {
          compression = "auto,lzma";
          encryption = {
            mode = "repokey-blake2";
            passCommand = "cat ${config.sops.secrets."borg/passphrase".path}";
          };
          environment = {
            BORG_RSH = "ssh -i ${config.sops.secrets."borg/ssh-private-key".path}";
          };
          paths = "/var/backup/postgresql";
          preHook = ''
            export BORG_REPO=$(cat ${config.sops.secrets."borg/repos/sovserv-postgresql".path})
          '';
          repo = "$BORG_REPO";
          startAt = "*-*-* 01:05:00";
        };
      };
    };
    caddy = {
      enable = true;
      # logFormat = ''
      #   level DEBUG
      # '';
      package = pkgs.callPackage ../shared/caddy.nix {
        plugins = [
          "github.com/caddy-dns/cloudflare"
        ];
      };
      virtualHosts."nextcloud.sovserv.top".extraConfig = ''
        reverse_proxy localhost:8080
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }
      '';
      # virtualHosts."fulcrum.finserv.top".extraConfig = ''
      #   reverse_proxy 100.124.142.57:50002
      #   tls {
      #     dns cloudflare {env.CF_API_TOKEN}
      #   }
      # '';
    };
    nextcloud = {
      # After enabling Nextcloud for the first time, there will be a warning in the administrative
      # settings about the database missing indexes.  To resolve, run this command once:
      # sudo nextcloud-occ db:add-missing-indices
      enable = true;
      autoUpdateApps.enable = true;
      config = {
        adminuser = "admin";
        adminpassFile = config.sops.secrets."nextcloud/admin-password".path;
        dbtype = "pgsql";
      };
      caching.redis = true;
      configureRedis = true;
      database.createLocally = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in nixpkgs at
        # github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud-apps.json
        inherit calendar contacts notes tasks; # onlyoffice

        # Custom app installation example
        # cookbook = pkgs.fetchNextcloudApp rec {
        #   url = "github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
        #   sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
        # };
      };
      hostName = "nextcloud.sovserv.top";
      https = true;
      maxUploadSize = "32G";
      package = pkgs.nextcloud28;
      phpOptions = {
        "opcache.interned_strings_buffer" = "48";
      };
      settings = {
        overwriteprotocol = "https";
        default_phone_region = "US";
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
        maintenance_window_start = "1";
        trusted_proxies = [ "127.0.0.1" ];
      };
    };
    nginx.virtualHosts = {
      "nextcloud.sovserv.top".listen = [{ addr = "127.0.0.1"; port = 8080; }];
    };
    onlyoffice = {
      enable = false;
      hostname = "onlyoffice.sovserv.top";
    };
    postgresql = {
      ensureDatabases = [ "nextcloud" ];
    };
    postgresqlBackup = {
      enable = true;
      databases = [ "nextcloud" ];
      startAt = "*-*-* 03:15:00";
    };
    tailscale.enable = true;
  };
  sops = {
    age.keyFile = "/home/main/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "borg/passphrase" = { };
      "borg/repos/sovserv-nextcloud" = { };
      "borg/repos/sovserv-postgresql" = { };
      "borg/ssh-private-key" = { };
      "caddy/cloudflare/api-token" = {
        owner = "caddy";
      };
      "nextcloud/admin-password" = {
        owner = "nextcloud";
      };
    };
  };

  systemd.services = {
    caddy = {
      serviceConfig = {
        AmbientCapabilities = "cap_net_bind_service";
        Environment = ''
          CF_API_TOKEN=${config.sops.secrets."caddy/cloudflare/api-token".path}
        '';
      };
    };
  };
}
