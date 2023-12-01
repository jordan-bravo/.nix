# ~/.nix/thinky/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
in
{
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  home = {
    homeDirectory = "/home/${username}";
    packages = [
      pkgs.nixgl.nixGLIntel
      # pkgs.makeDesktopItem {
      #   name = "KittyCustom";
      #   exec = "custom-command-to-launch-app";
      #   icon = pkgs.kitty; # Replace with the actual package providing your icon
      #   categories = [ "Terminal" "Console" ]; # Customize categories as needed
      # }
    ];
    username = "${username}";
  };
  programs.zsh.profileExtra = "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS";

  imports = [ ../shared/home.nix ../shared/linux-home.nix ];

  xdg.desktopEntries.kitty = {
    name = "Kitty";
    genericName = "Terminal Emulator";
    comment = "Fast, feature-rich, GPU based terminal";
    # tryExec = "nixGLIntel kitty";
    exec = "nixGLIntel kitty";
    icon = "kitty";
    categories = [ "System" "TerminalEmulator" ];
  };

  # xdg.systemDirs.data = [ "/home/jordan/.nix-profile/share" "/usr/local/share/" "/usr/share/" "/var/lib/snapd/desktop" ];
}

