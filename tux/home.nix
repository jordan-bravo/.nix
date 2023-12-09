# ~/.nix/tux/home.nix

{ config, pkgs, lib, ... }:

{
  dconf = {
    # enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        text-scaling-factor = 0.9; # BitLab LG
        # text-scaling-factor = 1.25; # Home Innocn
        # text-scaling-factor = 1.45; # tux built-in
      };
    };  
  };
  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [
      appimage-run # Run AppImages on NixOS
      bisq-desktop # Decentralized Bitcoin exchange
      ledger-live-desktop # App for ledger hardware signing device
      python311 # A high-level dynamically-typed programming language
      python311Packages.pip # Tool for installing Python packages
      signal-desktop # Signal desktop
      qbittorrent # Featureful free software BitTorrent client
      ricochet # Anonymous peer-to-peer instant messaging over Tor
      sparrow # Bitcoin wallet
    ];
  };
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];
}
