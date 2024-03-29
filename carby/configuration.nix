# ~/.nix/carby/configuration.nix

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 8;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "carby";

  # Enable networking
  networking.networkmanager.enable = true;

  # environment = {
  #   pathsToLink = [ "/share/zsh" ];
  #   variables = {
  #     "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
  #     # Hint electron apps to use wayland:
  #     sessionVariables.NIXOS_OZONE_WL = "1";
  #   };
  # };
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  services = {
    flatpak.enable = true;
    printing.enable = true;
    tailscale.enable = true;
    xserver = {
      enable = true;
      # Enable Gnome
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb.layout = "us";
      xkb.options = "caps:escape_shifted_capslock";
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jordan = {
    isNormalUser = true;
    description = "jordan";
    extraGroups = [ "adbusers" "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      home-manager
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    git
    neovim
    wl-clipboard
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # hyprland.enable = false;
    virt-manager.enable = false;
    zsh.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd.enable = false;
  };

  # There is an outstanding bug in NixOS that causes rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1645442729
  systemd.services.NetworkManager-wait-online.enable = false;
}
