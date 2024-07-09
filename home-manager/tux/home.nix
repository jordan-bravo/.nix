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
      nix-index # Files database for nixpkgs
      qbittorrent # Featureful free software BitTorrent client
      quickemu # Quickly create and run optimised Windows, macOS and Linux virtual machines
      quickgui # Flutter frontend for quickemu
      # ricochet-refresh # Anonymous peer-to-peer instant messaging over Tor
      sparrow # Bitcoin wallet

      # Deps attempting to install python 2 with pyenv
      # bzip2 # High-quality data compression program
      # gcc # GNU Compiler Collection
      # gdbm # GNU dbm key/value database library
      # gnumake # Tool to control the generation of non-source files from sources
      # gnupatch # GNU Patch, a program to apply differences to files
      # # libedit # Port of the NetBSD Editline library (libedit)
      # libffi # Foreign function call interface library
      # libnsl # Client interface library for NIS(YP) and NIS+
      # libuuid # Set of system utilities for Linux
      # openssl # Cryptographic library that implements the SSL and TLS protocols
      # readline # Library for interactive line editing
      # sqlite # Self-contained, serverless, zero-configuration, transactional SQL database engine
      # tk # Widget toolkit that provides a library of basic elements for building a GUI in many different programming languages
      # xz # General-purpose data compression software, successor of LZMA
      # zlib # Compression library
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
  programs.pyenv.enable = true;
}

