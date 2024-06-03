# thinky/home.nix

{ config, pkgs, pkgs-micro-2-0-12, ... }:

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
      # text-scaling-factor = 1.0;
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
      # pkgs-2311.nixd # Language server for Nix language
      pkgs-micro-2-0-12.micro
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
    ];
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
    username = "jordan";
  };
  imports = [
    ../shared/home.nix
    ../shared/workstations.nix
  ];
  nixpkgs.config.allowUnfree = true;
  programs.zsh.profileExtra = ''
    export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS"
    # The following shouldn't be needed because it's already in home-manager/shared/workstations.nix
    # Add ssh key
    # ssh-add ~/.ssh/ssh_id_ed25519_jordan@bravo
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
      brave-browser = {
        name = "Brave Nix";
        genericName = "Web Browser";
        comment = "Access the internet";
        exec = "nixGLIntel brave %U";
        icon = "brave-browser";
        categories = [ "Network" "WebBrowser" ];
        terminal = false;
      };
      element = {
        name = "Element Nix";
        genericName = "Matrix Client";
        comment = "A feature-rich client for Matrix.org";
        exec = "nixGLIntel element-desktop %u";
        icon = "element";
        categories = [ "Network" "InstantMessaging" "Chat" ];
      };
      firefox = {
        name = "Firefox";
        genericName = "Web Browser";
        exec = "nixGLIntel firefox --name firefox %U";
        icon = "firefox";
        categories = [ "Network" "WebBrowser" ];
        terminal = false;
      };
      kitty = {
        name = "Kitty";
        genericName = "Terminal Emulator";
        comment = "Fast, feature-rich, GPU based terminal";
        exec = "nixGLIntel kitty";
        icon = "kitty";
        categories = [ "System" "TerminalEmulator" ];
      };
      librewolf = {
        name = "Librewolf";
        genericName = "Web Browser";
        exec = "nixGLIntel librewolf --name librewolf %U";
        icon = "librewolf";
        categories = [ "Network" "WebBrowser" ];
        terminal = false;
      };
      obsidian = {
        name = "Obsidian Nix";
        comment = "Knowledge base";
        exec = "nixGLIntel obsidian %u";
        icon = "obsidian";
        categories = [ "Office" ];
        terminal = false;
      };
      slack = {
        name = "Slack Nix";
        genericName = "Slack Client for Linux";
        comment = "Slack Desktop";
        exec = "nixGLIntel slack -s %U";
        icon = "slack";
        categories = [ "Network" "InstantMessaging" ];
        terminal = false;
      };
    };
  };
}

