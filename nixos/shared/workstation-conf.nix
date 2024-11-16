# nixos/shared/workstation-conf.nix

{ pkgs, ... }:

{
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };

  environment = {
    # According to home-manager docs for programs.zsh.enableCompletion, adding the following
    # line enables completion for system packages (e.g. systemd)
    pathsToLink = [ "/share/zsh" ];
    sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    # variables = {
    #   "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
    # };
    # systemPackages = with pkgs; [
    #   # gcc # GNU Compiler Collection, version 13.2.0 (wrapper script)
    #   # openssl
    #   # pkg-config
    # ];
  };

  hardware.pulseaudio.enable = false;

  # Select internationalisation properties.
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

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # hyprland.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    flatpak.enable = true;
    mullvad-vpn.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    tailscale.enable = true;
    xserver = {
      # Enable the X11 windowing system.  I think this is required even with Wayland.
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Enable the KDE Plasma Desktop Environment.
      # displayManager.sddm.enable = true;
      # desktopManager.plasma5.enable = true;
      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
      xkb = {
        layout = "us";
        options = "caps:escape_shifted_capslock";
      };
    };
  };

  system.stateVersion = "23.11";

  time.timeZone = "America/New_York";

  users.users.jordan = {
    description = "jordan";
    extraGroups = [ "adbusers" "docker" "libvirtd" "networkmanager" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
      home-manager
    ];
    shell = pkgs.zsh; # Set the default shell for this user
  };

  # There is an outstanding bug in NixOS that causes rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1645442729
  # systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };
  };
}

