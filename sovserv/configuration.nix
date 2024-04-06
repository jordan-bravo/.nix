# ~/server-conf/sovserv/configuration.nix

{ config, inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };

  networking.hostName = "sovserv";

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.main = {
    description = "main";
    extraGroups = [ "networkmanager" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  # Hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    age # (Actually Good Encryption) A modern encryption tool with small explicit keys
    brave
    fuse # Required for borg mount
    hyprpaper
    kitty
    lsof
    neovim
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    nodePackages.pnpm # Fast, disck space efficient package manager for JavaScript
    pkg-config # Required for borg mount
    sops # Secrets OPerationS
    trash-cli
    # vim
    vlock # Lock the TTY screen
    waypipe
    wl-clipboard
    # xh # Friendly and fast tool for sending HTTP requests
    yarn # Package manager for JavaScript

    # Neovim dependencies (nvim-dep)
    fzf # nvim-dep
    gcc # nvim-dep
    gnumake # nvim-dep
    gopls # nvim-dep
    lazygit # nvim-dep
    lua-language-server # nvim-dep
    luajit # nvim-dep
    luajitPackages.jsregexp # nvim-dep
    luajitPackages.luacheck # nvim-dep
    nixd # nvim-dep
    nixpkgs-fmt # nvim-dep
    nodePackages.prettier # nvim-dep
    nodePackages.pyright # nvim-dep
    nodePackages.typescript # nvim-dep
    nodePackages.typescript-language-server # nvim-dep
    ripgrep # nvim-dep
    rustfmt # nvim-dep
    ruff # nvim-dep
    ruff-lsp # nvim-dep
    stylua # nvim-dep
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = false;
  };
  programs = {
    gnupg.agent = {
      enable = true;
    };
    hyprland.enable = true;
    ssh = {
      startAgent = true;
      # Add SSH public keys for Borgbase
      knownHosts = {
        "*.repo.borgbase.com" = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU0mISTyHBw9tBs6SuhSq8tvNM8m9eifQxM+88TowPO";
        };
      };
    };
    zsh.enable = true;
  };


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
      package = pkgs.callPackage ./caddy.nix {
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
      virtualHosts."fulcrum.finserv.top".extraConfig = ''
        reverse_proxy 192.168.1.192:50002
        tls {
          dns cloudflare {env.CF_API_TOKEN}
        }
      '';
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
    openssh = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
    xserver = {
      xkb = {
        layout = "us";
        options = "caps:escape_shifted_capslock";
      };
    };
  };
  security.rtkit.enable = true;
  sops = {
    age.keyFile = "/home/main/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
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

  system.stateVersion = "23.11";

  # There is an outstanding bug in NixOS that causes rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1645442729
  systemd.services.NetworkManager-wait-online.enable = false;

}
