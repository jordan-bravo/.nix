# ~/.nix/carby/configuration.nix

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };

  environment = {
    # pathsToLink = [ "/share/zsh" ]; 
    sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    systemPackages = with pkgs; [
      firefox
      git
      neovim
      wl-clipboard
    ];
    # variables = {
    #   "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
    # };
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
    hostName = "carby";
    networkmanager.enable = true;
    # nameservers = [
    #   "194.242.2.2"
    #   "2a07:e340::2"
    # ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    adb.enable = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # hyprland.enable = false;
    virt-manager.enable = false;
    zsh.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    resolved = {
      enable = false;
      dnssec = "false";
      domains = [ "~." ];
      fallbackDns = [ "194.242.2.2#dns.mullvad.net" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
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

  sound.enable = true;

  system.stateVersion = "23.11";

  time.timeZone = "America/New_York";

  users.users.jordan = {
    description = "jordan";
    extraGroups = [ "adbusers" "docker" "networkmanager" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
      home-manager
    ];
    shell = pkgs.zsh; # Set the default shell for this user
  };

  virtualisation = {
    libvirtd.enable = false;
    docker = {
      enable = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };
  };

  # There is an outstanding bug in NixOS that causes rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1645442729
  systemd.services.NetworkManager-wait-online.enable = false;
}