# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
in
{
  dconf.settings = {
    "desktop/ibus/panel/emoji" = {
      hotkey = [ ];
      unicode-hotkey = [ ];
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape_shifted_capslock" ];
    };
    "org/gnome/desktop/interface" = {
      # text-scaling-factor = 1.0; # BitLab LG
      # text-scaling-factor = 1.15; # Home Innocn
      text-scaling-factor = 1.45; # thinky built-in
    };
  };
  home = {
    file = {
      "daemon.json" = {
        enable = false;
        text = ''
          {
            "exampleKey": "exampleValue"
          }
        '';
      };
    };
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      # docker # Container engine
      gnome.gnome-calendar # Gnome calendar
      infisical # Manages secrets
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      # python310 # A high-level dynamically-typed programming language
    ];
    username = "${username}";
  };
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];
  nixpkgs.config.allowUnfree = true;
  programs.rtx.enable = true;
  programs.zsh.envExtra = ''
    export QT_STYLE_OVERRIDE="adwaita-dark"
  '';
  programs.zsh.profileExtra = ''
    export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS"
  '';
  targets.genericLinux.enable = true;
  xdg.desktopEntries.kitty = {
    name = "Kitty";
    genericName = "Terminal Emulator";
    comment = "Fast, feature-rich, GPU based terminal";
    exec = "nixGLIntel kitty";
    icon = "kitty";
    categories = [ "System" "TerminalEmulator" ];
  };
}

