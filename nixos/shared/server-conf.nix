# shared/server-conf.nix

{ config, inputs, pkgs, ... }:

{
  imports = [
    # inputs.sops-nix.nixosModules.sops
  ];

  # According to home-manager docs for programs.zsh.enableCompletion, adding the following
  # line enables completion for system packages (e.g. systemd)
  # environment.pathsToLink = [ "/share/zsh" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };

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

  users.defaultUserShell = pkgs.zsh;

  users.users.main = {
    description = "main";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
    ];
    useDefaultShell = true;
    # shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  # Hint electron apps to use wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # environment.systemPackages = with pkgs; [
  # ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = false;
  };
  programs = {
    gnupg.agent = {
      enable = true;
    };
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
    # borgbackup = {
    #   jobs = {
    #     example-job = {
    #       compression = "auto,lzma";
    #       encryption = {
    #         mode = "repokey-blake2";
    #         passCommand = "cat ${config.sops.secrets."borg/passphrase".path}";
    #       };
    #       environment = {
    #         BORG_RSH = "ssh -i ${config.sops.secrets."borg/ssh-private-key".path}";
    #       };
    #       paths = "/path/to/dir/to/backup";
    #       preHook = ''
    #         export BORG_REPO=$(cat ${config.sops.secrets."borg/repos/example-job".path})
    #       '';
    #       repo = "$BORG_REPO";
    #       startAt = "*-*-* 01:30:00";
    #     };
    #   };
    # };
    openssh = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # Examples
    # postgresql = {
    #   ensureDatabases = [ "name-of-database" ];
    # };
    # postgresqlBackup = {
    #   enable = true;
    #   databases = [ "name-of-database" ];
    #   startAt = "*-*-* 03:15:00";
    # };
    tailscale.enable = true;
    xserver = {
      xkb = {
        layout = "us";
        options = "caps:escape_shifted_capslock";
      };
    };
  };
  security.rtkit.enable = true;

  system.stateVersion = "23.11";

  # There is an outstanding bug in NixOS that causes rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1645442729
  systemd.services.NetworkManager-wait-online.enable = false;
}


