# ~/.nix/mbp/home.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory = "/Users/${username}";

in
{
  home = {
    username = username;
    homeDirectory = homeDirectory;
    packages = with pkgs; [
      delta # A syntax-highlighting pager for git
      # lazygit
      onefetch
      python2
      # python310Full
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

  imports = [ ../shared/home.nix ];

}
