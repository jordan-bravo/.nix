# thinky/home.nix

{ config, pkgs, /* pkgs-micro-2-0-12, */ ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # text-scaling-factor = 0.8; # BitLab LG
      # text-scaling-factor = 1.0;
      # text-scaling-factor = 1.15; # Home Innocn
      # text-scaling-factor = 1.5; # thinky built-in
      text-scaling-factor = 1.75; # extra large
      # text-scaling-factor = 2.0; # XXL
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
    file = {
      gpg-agent = {
        target = ".gnupg/gpg-agent.conf";
        enable = true;
        text = ''
          pinentry-program ${config.home.homeDirectory}/.nix-profile/bin/pinentry-gnome3
        '';
      };
    };
    packages = with pkgs; [
      infisical # Manages secrets
      kanata # Tool to improve keyboard comfort and usability with advanced customization
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      pinentry-gnome3
    ];
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
    username = "jordan";
  };
  imports = [
    ../shared/home.nix
    ../shared/workstations.nix
    ../shared/kanata.nix
  ];
  nixpkgs.config.allowUnfree = true;
  programs.zsh.profileExtra = ''
    export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
  '';
  programs.zsh.initExtra = ''
    export PATH=$HOME/.local/bin:$PATH
    # eval "$(mise activate zsh)"
  '';
  targets.genericLinux.enable = true;
  xdg = {
    configFile = {
      "kitty/kitty.conf" = {
        enable = true;
        text = ''
          font_family FiraCode Nerd Font Mono
          font_size 14

          include VSCode_Dark.conf

          # Shell integration is sourced and configured manually
          shell_integration no-rc

          dynamic_background_opacity yes
          enable_audio_bell no
          enabled_layouts horizontal, stack, vertical, grid
          hide_window_decorations yes
          macos_option_as_alt both
          placement_strategy top-left
          scrollback_lines 10000
          window_alert_on_bell no

          map ctrl+shift+tab 
          map ctrl+tab 
          map kitty_mod+1 goto_tab 1
          map kitty_mod+2 goto_tab 2
          map kitty_mod+3 goto_tab 3
          map kitty_mod+4 goto_tab 4
          map kitty_mod+5 goto_tab 5
          map kitty_mod+6 goto_tab 6
          map kitty_mod+7 goto_tab 7
          map kitty_mod+; goto_layout stack
          map kitty_mod+[ previous_window
          map kitty_mod+\ goto_layout vertical
          map kitty_mod+] next_window
          map kitty_mod+c copy_to_clipboard
          map kitty_mod+d scroll_page_down
          map kitty_mod+enter launch --cwd=current
          map kitty_mod+i goto_layout horizontal
          map kitty_mod+m next_tab
          map kitty_mod+n previous_tab
          map kitty_mod+o scroll_page_down
          map kitty_mod+space toggle_layout stack
          map kitty_mod+t launch --type=tab --cwd=current
          map kitty_mod+u scroll_page_up
          map kitty_mod+v paste_from_clipboard
          map kitty_mod+w close_window
          map kitty_mod+y goto_layout grid
        '';
      };
      "kitty/VSCode_Dark.conf" = {
        enable = true;
        text = ''
          # vim:ft=kitty
          ## name: VSCode_Dark
          ## author: ported from Microsoft VSCode by huabeiyou
          ## license: MIT
          ## blurb: the integrated terminal's default dark theme

          # The basic colors
          foreground              #cccccc
          background              #1e1e1e
          selection_foreground    #cccccc
          selection_background    #264f78

          # Cursor colors
          cursor                  #ffffff
          cursor_text_color       #1e1e1e

          # kitty window border colors
          active_border_color     #e7e7e7
          inactive_border_color   #414140

          # Tab bar colors
          active_tab_foreground   #ffffff
          active_tab_background   #3a3d41
          inactive_tab_foreground #858485
          inactive_tab_background #1e1e1e

          # black
          color0 #000000
          color8 #666666

          # red
          color1 #f14c4c
          color9 #cd3131

          # green
          color2  #23d18b
          color10 #0dbc79

          # yellow
          color3  #f5f543
          color11 #e5e510

          # blue
          color4  #3b8eea
          color12 #2472c8

          # magenta
          color5  #d670d6
          color13 #bc3fbc

          # cyan
          color6  #29b8db
          color14 #11a8cd

          # white
          color7  #e5e5e5
          color15 #e5e5e5
        '';
      };
    };
    desktopEntries = {
      brave-browser = {
        name = "Brave Nix";
        genericName = "Web Browser";
        comment = "Access the internet";
        exec = "nixGLIntel brave %U";
        # exec = "brave %U";
        icon = "brave-browser";
        categories = [ "Network" "WebBrowser" ];
        terminal = false;
      };
      element = {
        name = "Element Nix";
        genericName = "Matrix Client";
        comment = "A feature-rich client for Matrix.org";
        exec = "nixGLIntel element-desktop %u";
        # exec = "element-desktop %u";
        icon = "element";
        categories = [ "Network" "InstantMessaging" "Chat" ];
      };
      firefox = {
        name = "Firefox Nix";
        genericName = "Web Browser";
        exec = "nixGLIntel firefox --name firefox %U";
        # exec = "firefox --name firefox %U";
        icon = "firefox";
        categories = [ "Network" "WebBrowser" ];
        terminal = false;
      };
      # kitty = {
      #   name = "Kitty";
      #   genericName = "Terminal Emulator";
      #   comment = "Fast, feature-rich, GPU based terminal";
      #   # exec = "nixGLIntel kitty";
      #   exec = "kitty";
      #   icon = "kitty";
      #   categories = [ "System" "TerminalEmulator" ];
      # };
      librewolf = {
        name = "Librewolf";
        genericName = "Web Browser";
        exec = "nixGLIntel librewolf --name librewolf %U";
        # exec = "librewolf --name librewolf %U";
        icon = "librewolf";
        categories = [ "Network" "WebBrowser" ];
        terminal = false;
      };
      obsidian = {
        name = "Obsidian Nix";
        comment = "Knowledge base";
        exec = "nixGLIntel obsidian %u";
        # exec = "obsidian %u";
        icon = "obsidian";
        categories = [ "Office" ];
        terminal = false;
      };
      slack = {
        name = "Slack Nix";
        genericName = "Slack Client for Linux";
        comment = "Slack Desktop";
        exec = "nixGLIntel slack -s %U";
        # exec = "slack -s %U";
        icon = "slack";
        categories = [ "Network" "InstantMessaging" ];
        terminal = false;
      };
    };
  };
}

