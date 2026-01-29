# sovserv/configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nixos-all.nix
    ../../modules/nixos/nixos-server.nix
  ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
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
        sovserv-obsidian = {
          compression = "auto,lzma";
          encryption = {
            mode = "repokey-blake2";
            passCommand = "cat ${config.sops.secrets."borg/passphrase".path}";
          };
          environment = {
            BORG_RSH = "ssh -i ${config.sops.secrets."borg/ssh-private-key".path}";
          };
          paths = "/var/lib/couchdb";
          preHook = ''
            export BORG_REPO=$(cat ${config.sops.secrets."borg/repos/sovserv-obsidian".path})
          '';
          repo = "$BORG_REPO";
          startAt = "*-*-* 01:45:00";
        };
      };
    };
    couchdb = {
      enable = true;
      bindAddress = "127.0.0.1";
      port = 5984;
      extraConfig = {
        chttpd = {
          max_http_request_size = "4294967296";
          enable_cors = "true";
        };
        couchdb = {
          max_document_size = "50000000";
        };
        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = "true";
          headers = "accept,authorization,content-type,origin,referer";
          methods = "GET,PUT,POST,HEAD,DELETE";
        };
      };
    };
    matrix-conduit = {
      enable = false;
      settings.global = {
        allow_federation = true;
        allow_registration = true;
        # You will need this token when creating your first account.
        registration_token = "rigel";
        server_name = "matrix.sovserv.top";
        port = 6167;
        address = "0.0.0.0";
        database_backend = "rocksdb";
        trusted_servers = [ "matrix.org" ];
      };
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
        inherit bookmarks calendar contacts cookbook forms notes notify_push onlyoffice tasks uppush whiteboard;

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
      # When updating nextcloud versions, you might see redis fail to start. If so, disable nextcloud, then 
      # delete dump.rdb, then re-enable nextcloud
      package = pkgs.nextcloud32;
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
      enable = true;
      virtualHosts = {
        "nextcloud.sovserv.top".listen = [{ addr = "0.0.0.0"; port = 8080; }];
        "obsidian.sovserv.top" = {
          listen = [{ addr = "0.0.0.0"; port = 8081; }];
          locations."/" = {
            proxyPass = "http://127.0.0.1:5984";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_buffering off;
            '';
          };
        };
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
  };
  sops = {
    age.keyFile = "/home/main/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/sops-secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "borg/passphrase" = { };
      "borg/repos/sovserv-nextcloud" = { };
      "borg/repos/sovserv-postgresql" = { };
      "borg/repos/sovserv-obsidian" = { };
      "borg/ssh-private-key" = { };
      # "caddy/cloudflare/api-token-env-var" = {
      #   owner = "caddy";
      # };
      "couchdb/admin-password" = {
        owner = "couchdb";
      };
      "nextcloud/admin-password" = {
        owner = "nextcloud";
      };
    };
  };

  systemd.services.bravo-site = {
    description = "Bravo Site Jekyll Build and Python Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "main";
      Group = "users";
      WorkingDirectory = "/home/main/apps/jordan-bravo.github.io";
      ExecStartPre = pkgs.writeShellScript "build-bravo-site" ''
        cd /home/main/apps/jordan-bravo.github.io
        ${pkgs.nix}/bin/nix develop --command bash -c "bundle install && bundle exec jekyll build"
      '';

      # Serve the _site directory with Python
      ExecStart = pkgs.writeShellScript "serve-bravo-site" ''
        cd /home/main/apps/jordan-bravo.github.io
        ${pkgs.nix}/bin/nix develop --command python -m http.server 4000 --directory _site
      '';

      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  systemd.services.couchdb-setup-password = {
    description = "Setup CouchDB Admin Password";
    before = [ "couchdb.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "couchdb-setup-password" ''
        # Ensure the couchdb data directory exists
        mkdir -p /var/lib/couchdb

        # Read admin password from sops secret
        ADMIN_PASS=$(cat ${config.sops.secrets."couchdb/admin-password".path})

        # Write admin credentials to local.ini (CouchDB will hash it on first read)
        cat > /var/lib/couchdb/local.ini <<EOF
[admins]
admin = $ADMIN_PASS
EOF

        # Set proper ownership
        chown couchdb:couchdb /var/lib/couchdb/local.ini
        chmod 600 /var/lib/couchdb/local.ini
      '';
    };
  };

  systemd.services.couchdb-init = {
    description = "Initialize CouchDB for Obsidian LiveSync";
    after = [ "couchdb.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "couchdb-init" ''
        # Wait for CouchDB to be ready
        until ${pkgs.curl}/bin/curl -s http://127.0.0.1:5984/ > /dev/null 2>&1; do
          echo "Waiting for CouchDB to start..."
          sleep 2
        done

        # Read admin credentials
        ADMIN_USER="admin"
        ADMIN_PASS=$(cat ${config.sops.secrets."couchdb/admin-password".path})

        # Configure single node
        ${pkgs.curl}/bin/curl -s -u "$ADMIN_USER:$ADMIN_PASS" -X PUT "http://127.0.0.1:5984/_node/_local/_config/couchdb/single_node_setup" -d '"true"'

        # Create _users database if it doesn't exist
        ${pkgs.curl}/bin/curl -s -u "$ADMIN_USER:$ADMIN_PASS" -X PUT "http://127.0.0.1:5984/_users"

        # Create _replicator database if it doesn't exist
        ${pkgs.curl}/bin/curl -s -u "$ADMIN_USER:$ADMIN_PASS" -X PUT "http://127.0.0.1:5984/_replicator"

        echo "CouchDB initialized for Obsidian LiveSync"
      '';
    };
  };
  users.users.bravo-site = {
    isSystemUser = true;
    group = "bravo-site";
    home = "/home/main/apps/jordan-bravo.github.io";
  };
  users.groups.bravo-site = { };

  # systemd.services.caddy = {
  #   serviceConfig = {
  #     AmbientCapabilities = "cap_net_bind_service";
  #     EnvironmentFile = "${config.sops.secrets."caddy/cloudflare/api-token-env-var".path}";
  #   };
  # };
}
