# ~/.nix/tux/home.nix

{ config, pkgs, lib, ... }:

# let
#   username = "jordan";
#   homeDirectory = "/home/${username}";
#
# in
{
  fonts.fontconfig.enable = true;
  home = {
    # homeDirectory = homeDirectory;
    # username = username;
    packages = with pkgs; [

    ];
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    stateVersion = "23.05";
  };

  dconf.enable = true;
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];

  services = {
    copyq.enable = true;
  };

}
