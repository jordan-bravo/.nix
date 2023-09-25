# ~/.nix/mbp/home.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory = "/Users/${username}";

in
{
  home = {
    file = { };
    homeDirectory = homeDirectory;
    packages = with pkgs; [
      # delta # A syntax-highlighting pager for git
    ];
    username = username;
  };

  imports = [ ../shared/home.nix ];

  programs.rtx.enable = true;
  programs.zsh.initExtra = ''
    # python versions for alta-legacy
    # python2
    export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"

    # python3
    export PATH="/opt/homebrew/opt/python@3.10/libexec/bin:$PATH"
  '';

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
    # configFile = {
    #   # "skhd/skhdrc".source = ./skhd.conf;
    #   skhd = {
    #     recursive = true;
    #     source = ./skhd;
    #   };
    #   yabai = {
    #     recursive = true;
    #     source = ./yabai;
    #   };
    # };
  };

}
