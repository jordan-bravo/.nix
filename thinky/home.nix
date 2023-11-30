# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
in
{
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  home = {
    file = {
      kittyNixgl = {
        enable = true;
        target = ".local/share/applications/kitty-nixgl.desktop";
        text = ''
          [Desktop Entry]
          Version=1.0
          Type=Application
          Name=kittygl
          GenericName= Terminal emulator
          Comment=Fast, feature-rich, GPU based terminal
          TryExec=nixGLIntel kitty
          Exec=nixGLIntel kitty
          Icon=kitty
          Categories=System;TerminalEmulator;
        '';
      };
    };
    homeDirectory = "/home/${username}";
    packages = [
      pkgs.nixgl.nixGLIntel
      # pkgs.makeDesktopItem {
      #   name = "KittyCustom";
      #   exec = "custom-command-to-launch-app";
      #   icon = pkgs.kitty; # Replace with the actual package providing your icon
      #   categories = [ "Terminal" "Console" ]; # Customize categories as needed
      # }
    ];
    username = "${username}";
  };

  imports = [ ../shared/home.nix ../shared/linux-home.nix ];

  # programs.kitty.package = pkgs.nixgl.nixGLIntel;

  # xdg.systemDirs.data = [ "/home/jordan/.nix-profile/share" "/usr/local/share/" "/usr/share/" "/var/lib/snapd/desktop" ];
}

