# ~/.nix/tux/configuration.nix

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-7e6c1e38-88c4-4f94-b580-eaa693d54233" = {
    device = "/dev/disk/by-uuid/7e6c1e38-88c4-4f94-b580-eaa693d54233";
    keyFile = "/crypto_keyfile.bin";
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    variables = {
      "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
    };
  };

  hardware = {
    ledger.enable = true; # Ledger hardware signing device.
  };

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
    hostName = "tux";
    networkmanager.enable = true;
    nameservers = [
      "194.242.2.2"
      "2a07:e340::2"
    ];
  };

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    keep-outputs = true;
    keep-derivations = true;
    # package = pkgs.nixFlakes;
    # registry.nixpkgs.flake = inputs.nixpkgs;
  };

  # nix.registry.nixpkgs = {
  #   from = {
  #     id = "nixpkgs";
  #     type = "indirect";
  #   };
  #   flake = flake-inputs.nixpkgs;
  # };


  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    flatpak.enable = true;
    ivpn.enable = true;
    printing.enable = true;
    resolved = {
      enable = true;
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
      layout = "us";
      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
      xkbVariant = "";
      xkbOptions = "caps:escape_shifted_capslock";
    };
  };


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    # audio.enable = true; # this was in previous tux config
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  system.stateVersion = "23.11";
  # Set your time zone.
  time.timeZone = "America/New_York";
  users.users.jordan = {
    isNormalUser = true;
    description = "jordan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh; # Set the default shell for this user
    packages = with pkgs; [
      git
    ];
  };
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    # rootless = {
    # 	enable = true;
    # 	setSocketVariable = true;
    # };
  };

  # There is an outstanding bug in NixOS that causes rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1645442729
  systemd.services.NetworkManager-wait-online.enable = false;
}
