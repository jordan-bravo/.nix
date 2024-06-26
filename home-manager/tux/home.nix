# ~/.nix/tux/home.nix

{ config, pkgs, ... }:

{
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        # text-scaling-factor = 0.8; # BitLab LG
        # text-scaling-factor = 1.0; # Normal scaling
        # text-scaling-factor = 1.25; # Home Innocn
        text-scaling-factor = 1.45; # tux built-in
      };
      "org/gnome/desktop/peripherals/mouse" = {
        speed = -0.8;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        speed = 0.25;
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
      # "org/gnome/desktop/sound" = {
      #   allow-volume-above-100-percent = true;
      # };
    };
  };
  home = {
    packages = with pkgs; [
      appimage-run # Run AppImages on NixOS
      bisq-desktop # Decentralized Bitcoin exchange
      qbittorrent # Featureful free software BitTorrent client
      # ricochet-refresh # Anonymous peer-to-peer instant messaging over Tor
      sparrow # Bitcoin wallet
    ];
    # homeDirectory = "/home/${config.home.username}";
    # username = "jordan";
  };
  imports = [
    ../shared/home.nix
    ../shared/kitty.nix
    ../shared/workstations.nix
    # ../shared/hyprland.nix
    # android-nixpkgs.hmModule {
    #   
    # }
  ];
  programs.zsh.initExtra = ''
    # Fix bug on NixOS with up arrow (nixos.wiki/wiki/Zsh)
    bindkey "''${key[Up]}" up-line-or-search
  '';
}

