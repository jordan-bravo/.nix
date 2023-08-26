# ~/.nix/mbp/home.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory = "/Users/${username}";

in
{
  fonts.fontconfig.enable = true;
  home.username = username;
  home.homeDirectory = homeDirectory;


  home.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
    delta # A syntax-highlighting pager for git
    # gnupg
    # lazygit
    onefetch
    # sl # Steam Locomotive run across your terminal when you type sl
    # firefox # Web browser
    # brave # Web browser
    # wget # File retriever
    # git # Version control system
  ];

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

  imports = [ ../shared/home.nix ];

}
