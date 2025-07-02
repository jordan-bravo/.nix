{ pkgs, sparrow-pkgs, ... }:

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
  networking.hostName = "tux";
  # This might be needed to specify additional binary caches
  # nix.settings.trusted-users = [ "root" "jordan" ];

  environment.systemPackages = with pkgs; [
    element-desktop # Matrix client
    sparrow-pkgs.sparrow # Pinned to v2.0.0 because v2.2.1 has a bug where clicking on the "send" tab doesn't work
  ];

  # fonts.packages = with pkgs; [
  #   nerd-fonts.fira-code
  # ];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;


  # Remap keys

  ### Remap keys using xremap
  # services.xremap = {
  #   enable = false;
  #   withGnome = true;
  #   serviceMode = "system";
  #   userName = "jordan";
  #   config = {
  #     modmap = [
  #       {
  #         name = "Global";
  #         remap = { "Context_Menu" = "RightMeta"; };
  #       }
  #     ];
  #   };
  #   debug = true;
  #   watch = true;
  # };
  # hardware.uinput.enable = true;
  # users.groups.uinput.members = [ "jordan" ];
  # users.groups.input.members = [ "jordan" ];

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

  # The following is to get customer engine working on NixOS
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #     stdenv.cc.cc.lib
  #     xorg.libX11
  #     xorg.libxcb
  #     # xorg.libXcomposite # For VSCodium extension Markdown PDF
  #     # zlib # numpy
  #     # libgcc # sqlalchemy
  #     # zlib
  #     # that's where the shared libs go, you can find which one you need using
  #     # nix-locate --top-level libstdc++.so.6  (replace this with your lib)
  #   ];
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
