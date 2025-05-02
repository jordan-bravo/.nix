# sovserv/configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/server-conf.nix
    ../shared/shared-conf.nix
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
    couchdb = {
      enable = false;
    };
    nextcloud = {
      # After enabling Nextcloud for the first time, there might be a warning in the administrative
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
        # List of apps we can install that are already packaged in nixpkgs at:
        # github.com/nixos/nixpkgs/blob/nixos-unstable/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts cookbook forms notes notify_push onlyoffice tasks uppush whiteboard;

        # Custom app installation example, if cookbook weren't packaged
        # cookbook = pkgs.fetchNextcloudApp {
        #   url = "github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
        #   sha256 = "sha256-H7KVeISBnu0/4Q31ihhiXvRtkXz4yLGOAsAj5ERgeCM=";
        #   license = "gpl3";
        # };
      };
      hostName = "nextcloud.sovserv.top";
      https = true;
      maxUploadSize = "32G";
      # After upgrading to Nextcloud 29, there is a error in Admin settings:
      # Failed to get an iterator for log entries: Logreader application only supports "file" log_type
      # The Nextcloud forums list a solution:  remove this line from config.php:
      # 'log_type' => 'errorlog',
      # The question is, how to do this on NixOS?
      package = pkgs.nextcloud30;
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
        # maintenance = true; # set this to true to manually enable maintenance mode
        maintenance_window_start = "1";
        trusted_proxies = [ "127.0.0.1" ];
      };
    };
    nginx = {
      # enable = true;
      virtualHosts = {
        "nextcloud.sovserv.top".listen = [{ addr = "0.0.0.0"; port = 8080; }];
      };
    };
    onlyoffice = {
      enable = false;
      hostname = "onlyoffice.sovserv.top";
    };
    postgresql = {
      ensureDatabases = [ "nextcloud" ];
      package = pkgs.postgresql_15;
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
    defaultSopsFile = ../../secrets/sops-secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "borg/passphrase" = { };
      "borg/repos/sovserv-nextcloud" = { };
      "borg/repos/sovserv-postgresql" = { };
      "borg/ssh-private-key" = { };
      # "caddy/cloudflare/api-token-env-var" = {
      #   owner = "caddy";
      # };
      "nextcloud/admin-password" = {
        owner = "nextcloud";
      };
    };
  };

  # systemd.services = {
  #   caddy = {
  #     serviceConfig = {
  #       AmbientCapabilities = "cap_net_bind_service";
  #       EnvironmentFile = "${config.sops.secrets."caddy/cloudflare/api-token-env-var".path}";
  #     };
  #   };
  # };
}
