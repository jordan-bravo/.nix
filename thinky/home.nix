# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
in
{
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  home = {
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

