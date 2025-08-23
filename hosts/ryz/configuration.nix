{ pkgs, /* sparrow-pkgs, */ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nixos-all.nix
    ../../modules/nixos/nixos-workstation.nix
    # inputs.xremap-flake.nixosModules.default
  ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 4;
  };
  networking.hostName = "ryz";
  # This might be needed to specify additional binary caches
  # nix.settings.trusted-users = [ "root" "jordan" ];

  environment.systemPackages = with pkgs; [
    # element-desktop # Matrix client
    # sparrow-pkgs.sparrow # Pinned to v2.0.0 because v2.2.1 has a bug where clicking on the "send" tab doesn't work
    sparrow
  ];

  # fonts.packages = with pkgs; [
  #   nerd-fonts.fira-code
  # ];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Systemd service to disable ThinkPad Lid LED
  # This doesn't seem to be working when suspended
  systemd.services.thinkpad-disable-led = {
    description = "Disables the red logo LED at startup";
    after = [ "basic.target" "suspend.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "/run/current-system/sw/bin/sh -c 'echo 0 | tee /sys/class/leds/tpacpi::lid_logo_dot/brightness'";
    };
    wantedBy = [ "basic.target" "suspend.target" ];
  };

  ### Secure Boot using lanzaboote

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };

}

/*
  Packages currently not being used but handy for later
*/

# bisq-desktop # Decentralized Bitcoin exchange
# cachix # Command-line client for Nix binary cache hosting https://cachix.org
# bulky # Bulk rename app
# gprename # Complete batch renamer for files and directories
# greetd.gtkgreet
# nix-index # Files database for nixpkgs
# niv # Easy dependency management for Nix projects # Dependency of lanzaboote
# quickemu # Quickly create and run optimised Windows, macOS and Linux virtual machines
# quickgui # Flutter frontend for quickemu
# ricochet-refresh # Anonymous peer-to-peer instant messaging over Tor
# sbctl # Secure Boot key manager # Dependency of lanzaboote
# trayscale # Unofficial GUI wrapper around the Tailscale CLI client
