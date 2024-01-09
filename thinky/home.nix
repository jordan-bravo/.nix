# ~/.nix/thinky/home.nix

{ config, pkgs, ... }:

{
  dconf.settings = {
    "desktop/ibus/panel/emoji" = {
      hotkey = [ ];
      unicode-hotkey = [ ];
    };
    "org/gnome/desktop/interface" = {
      # text-scaling-factor = 0.8; # BitLab LG
      # text-scaling-factor = 1.15; # Home Innocn
      text-scaling-factor = 1.5; # thinky built-in
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.3;
      tap-to-click = true;
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = false;
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
    packages = with pkgs; [
      # docker # Container engine
      gnome.gnome-calendar # Gnome calendar
      infisical # Manages secrets
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      neovim # Text editor / IDE
      python311Packages.debugpy # An implementation of the Debug Adapter Protocol for Python
      python311 # A high-level dynamically-typed programming language
    ];
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.11";
    username = "jordan";
  };
  imports = [ ../shared/home.nix ../shared/linux-home.nix ];
  nixpkgs.config.allowUnfree = true;
  programs.rtx.enable = true;
  programs.zsh.profileExtra = ''
    export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS"
  '';
  targets.genericLinux.enable = true;
  xdg = {
    configFile = {
      "kitty/kitty-session.conf" = {
        enable = true;
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
      # brave-browser = {
      #   name = "Brave";
      #   genericName = "Web Browser";
      #   comment = "Access the Inernet";
      #   exec = "/nix/store/7pr6j2qjhlf0j4i1wxzzvg3lxr3hyccc-brave-1.61.109/bin/brave %U";
      #   startupNotify = true;
      #   terminal = false;
      #   icon = "brave-browser";
      #   type = "Application";
      #   categories = [ "Network" "WebBrowser" ];
      # };
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

