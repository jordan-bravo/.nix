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
    # bat # Modern replacement for cat
    delta # A syntax-highlighting pager for git
    # gnupg
    # lazygit
    # neovim # Text editor
    onefetch
    # wezterm # Terminal emulator
    # sl # Steam Locomotive run across your terminal when you type sl
    # nerdfonts # Patched fonts and icons
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
