{ pkgs, ... }:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 4;
  };
  # According to home-manager docs for programs.zsh.enableCompletion, adding the following
  # line enables completion for system packages (e.g. systemd)
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };
  time.timeZone = "America/New_York";
  networking = {
    enableIPv6 = false;
    firewall.checkReversePath = "loose"; # This is required for Tailscale exit node to work
    nameservers = [ "9.9.9.9" "149.112.112.112" ]; # Quad9
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };
  boot.kernelParams = [ "ipv6.disable=1" ];

  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    # sandbox = false; # This is true by default. Only set to false if necessary.
  };
  programs = {
    gnupg.agent = {
      enable = true;
      # enableSSHSupport = true; # is this necessary?
    };
    ssh.startAgent = true;
    zsh.enable = true;
  };
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      xkb = {
        layout = "us";
        options = "caps:escape_shifted_capslock";
      };
    };
  };
  # # There is an outstanding bug with NetworkManager that causes NixOS rebuilds to fail sometimes, this is the workaround.
  # # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  # systemd.services.NetworkManager-wait-online = {
  #   serviceConfig = {
  #     ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
  #   };
  # };
  system.stateVersion = "25.05";
  virtualisation = {
    # libvirtd.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
