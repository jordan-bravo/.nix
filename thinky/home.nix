# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

{
  # fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "jordan";
    homeDirectory = "/home/jordan";
    packages = with pkgs; [
    ];
  };

  # dconf.enable = true;
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];

  # services = {
  #   copyq.enable = true;
  # };

  # xdg.systemDirs.data = [ "/home/jordan/.nix-profile/share" "/usr/local/share/" "/usr/share/" "/var/lib/snapd/desktop" ];
}

