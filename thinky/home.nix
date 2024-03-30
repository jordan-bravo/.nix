# ~/.nix/thinky/home.nix

{ config, pkgs, pkgs-2311, ... }:

{
  dconf.settings = {
    # This is a failed attempt to solve a Ubuntu/Gnome bug:
    # Can't unset Unicode code point shortcut (ctrl+shift+u)
    # https://gitlab.gnome.org/GNOME/gtk/-/issues/5865
    # Developer won't fix. Probably need to upgrade Ubuntu to fix
    "desktop/ibus/panel/emoji" = {
      hotkey = [ ];
      unicode-hotkey = [ ];
    };
    "org/gnome/desktop/interface" = {
      # text-scaling-factor = 0.8; # BitLab LG
      # text-scaling-factor = 1.15; # Home Innocn
      text-scaling-factor = 1.5; # thinky built-in
    };
    "org/gnome/desktop/peripherals/mouse" = {
      speed = -0.6;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.3;
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = false;
    };
  };
  home = {
    packages = with pkgs; [
      gnome.gnome-calendar # Gnome calendar
      infisical # Manages secrets
      pkgs-2311.nixd # Language server for Nix language
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
    ];
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
    username = "jordan";
  };
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];
  nixpkgs.config.allowUnfree = true;
  programs.zsh.profileExtra = ''
    export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS"
  '';
  targets.genericLinux.enable = true;
  xdg = {
    configFile = {
      "kitty/kitty-session.conf" = {
        enable = false;
        text = ''
          # How to set the title of the first tab to .nix?
          # Set the working directory for windows in the current tab
          cd ~/.nix
          launch zsh
          # launch vim

          # Create a new tab for legacy
          new_tab legacy
          cd ~/bd/legacy
          launch zsh
          # launch vim

          # Create a new tab for alta
          new_tab alta
          cd ~/bd/alta
          launch zsh
          # launch vim
        '';
      };
    };
    desktopEntries = {
      kitty = {
        name = "Kitty";
        genericName = "Terminal Emulator";
        comment = "Fast, feature-rich, GPU based terminal";
        exec = "nixGLIntel kitty";
        icon = "kitty";
        categories = [ "System" "TerminalEmulator" ];
      };
    };
  };
}

