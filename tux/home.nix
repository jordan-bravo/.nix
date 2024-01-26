# ~/.nix/tux/home.nix

{ config, pkgs, ... }:

{
  dconf = {
    # enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        # text-scaling-factor = 0.9; # BitLab LG
        text-scaling-factor = 1.25; # Home Innocn
        # text-scaling-factor = 1.45; # tux built-in
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        speed = 0.25;
        tap-to-click = true;
      };
      "org/gnome/desktop/sound" = {
        allow-volume-above-100-percent = false;
      };
    };
  };
  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [
      appimage-run # Run AppImages on NixOS
      bisq-desktop # Decentralized Bitcoin exchange
      # ledger-live-desktop # App for ledger hardware signing device
      # python311 # A high-level dynamically-typed programming language
      # python311Packages.pip # Tool for installing Python packages
      qbittorrent # Featureful free software BitTorrent client
      ricochet # Anonymous peer-to-peer instant messaging over Tor
      sparrow # Bitcoin wallet
    ];
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
    username = "jordan";
  };
  imports = [
    ../shared/home.nix
    ../shared/linux-home.nix
    # android-nixpkgs.hmModule {
    #   
    # }
  ];
  nixpkgs.config.allowUnfree = true;
  xdg.configFile."kitty/kitty-session.conf" = {
    enable = true;
    text = ''
      # How to set the title of the first tab to .nix?
      # Set the working directory for windows in the current tab
      cd ~/.nix
      launch zsh
      # launch vim

      # Create a new tab for scm
      new_tab scm
      cd ~/scm/
      launch zsh
      # launch vim
    '';
  };
}
