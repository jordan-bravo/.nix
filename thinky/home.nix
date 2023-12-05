# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
in
{
  dconf.settings = {
    "desktop/ibus/panel/emoji" = {
      hotkey =  [];
      unicode-hotkey =  [];
    };
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.45; # thinky built-in
      # text-scaling-factor = 1.25; # Home Innocn
      # text-scaling-factor = 1.0; # BitLab LG
    };
  };
  home = {
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      gnome.gnome-calendar
      nixgl.nixGLIntel
    ];
    username = "${username}";
  };
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];
  nixpkgs.config.allowUnfree = true;
  programs.rtx.enable = true;
  programs.zsh.profileExtra = "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS";
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

