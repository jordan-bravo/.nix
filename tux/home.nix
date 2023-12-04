# ~/.nix/tux/home.nix

{ config, pkgs, lib, ... }:

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        text-scaling-factor = 1.45; # tux built-in
        # text-scaling-factor = 1.25; # Home Innocn
        # text-scaling-factor = 1.0; # BitLab LG
      };
    };  
  };
  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [

    ];
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    stateVersion = "23.05";
  };
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];
}
