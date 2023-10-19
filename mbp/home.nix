# ~/.nix/mbp/home.nix

{ config, pkgs, ... }:

{
  home = {
    # file = { };
    packages = with pkgs; [
    ];
  };

  imports = [ ../shared/home.nix ];

  programs.zsh.initExtra = ''
    # python versions for alta-legacy
    # python2
    export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:''${PATH}"

    # python3
    export PATH="/opt/homebrew/opt/python@3.10/libexec/bin:''${PATH}"
  '';

  # xdg = {
  #   enable = true;
  #   configHome = "${homeDirectory}/.config";
  #   # configFile = {
  #   #   # "skhd/skhdrc".source = ./skhd.conf;
  #   #   skhd = {
  #   #     recursive = true;
  #   #     source = ./skhd;
  #   #   };
  #   #   yabai = {
  #   #     recursive = true;
  #   #     source = ./yabai;
  #   #   };
  #   # };
  # };

}
