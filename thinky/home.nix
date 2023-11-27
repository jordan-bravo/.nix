# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

{
  targets.genericLinux.enable = true;
  # fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "jordan";
    homeDirectory = "/home/jordan";
    packages = with pkgs; [
    ];
  };

  imports = [ ../shared/home.nix ../shared/linux-home.nix ];

  # xdg.systemDirs.data = [ "/home/jordan/.nix-profile/share" "/usr/local/share/" "/usr/share/" "/var/lib/snapd/desktop" ];
}

