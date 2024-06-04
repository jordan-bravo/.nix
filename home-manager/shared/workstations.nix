# home-manager/shared/workstations.nix

{ config, pkgs, ... }:

{
  home = {
    file = {
      iamb-config = {
        target = ".config/iamb/config.toml";
        enable = true;
        text = ''
          [profiles.user]
          user_id = "@jordanbravo:matrix.org"
        '';
      };
    };
    packages = with pkgs; [
      act # Run your GitHub Actions locally
      adwaita-qt # Adwaita style for Qt apps
      aerc # An email client for your terminal
      audacity # Music player
      android-studio # The Official IDE for Android (stable channel)
      android-tools # Android SDK platform tools
      avidemux # Free video editor designed for simple video editing tasks
      beekeeper-studio # SQL database client
      bitcoind # Peer-to-peer electronic cash system
      bitwarden # Password manager
      # borgbackup # Deduplicating archiver with compression and encryption
      brave # Web browser
      # cantarell-fonts # Fonts for waybar
      # dbeaver # SQL database client
      dino # XMPP client
      discord # All-in-one cross-platform voice and text chat for gamers
      # dpkg # The Debian package manager
      # dunst # Notification daemon
      element-desktop # Matrix client
      firefox # Web browser
      # font-awesome # Fonts for waybar
      fractal # Matrix client
      freetube # YouTube client
      # gtklock # Screen lock
      # gtklock-userinfo-module # Screen lock user info
      heroku # Heroku CLI
      hoppscotch # Open source API development ecosystem, Postman alternative
      iamb # Matrix client for Vim addicts
      jitsi-meet # Video calling (not sure if both packages are needed)
      jitsi # Video calling (not sure if both packages are needed)
      krename # A powerful batch renamer for KDE
      librewolf # A fork of Firefox, focused on privacy, security, and freedom
      nextcloud-client # Nextcloud sync client
      obsidian # Note-taking # Weird bug in gnome on tux, can't see window
      onlyoffice-bin # Office suite
      pinta # Image editor
      polkit_gnome # Authentication agent
      postman # API development environment
      signal-desktop # Signal desktop
      slack # Desktop client for Slack
      # spot # Native Spotify client for the GNOME desktop
      # standardnotes # Note-taking
      telegram-desktop # Messaging client
      thunderbird # Email client
      tor-browser-bundle-bin # Tor browser
      vlc # Media player
      vorta # Desktop Backup Client for Borg
      # waybar # Status bar
      # wofi # App launcher
      xorg.xwininfo # Display info for X windows and nothing for Wayland windows
      # zoom-us # Video conferencing

      # GNOME specific
      gnome.dconf-editor # Edit GNOME options
      gnome.gnome-session # GNOME session manager, e.g. `gnome-session-quit`
      gnome.gnome-tweaks # Extra options for GNOME
      gnome-extension-manager # Manage GNOME extensions
      gnomeExtensions.appindicator # Tray icons
      gnomeExtensions.auto-move-windows # Move applications to specific workspaces when they create windows
      gnomeExtensions.dash-to-dock # Customize the dash
      gnomeExtensions.gsconnect # Transfer files & clipboard across devices
      gnomeExtensions.just-perfection # Customize GNOME shell and UI
      gnomeExtensions.nextcloud-folder # Open Nextcloud folder in one click
      gnomeExtensions.unblank # Keep display on when GNOME locks
      gnomeExtensions.vitals # System info in status bar
      gnomeExtensions.space-bar # Adds workspaces to status bar

      # pkgs-neovim-094.neovim
    ];
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    stateVersion = "23.11";
  };

  # Programs with more extensive config are imported from separate modules.
  imports = [
    ../shared/dconf.nix
    ../shared/kitty.nix
  ];

  # Programs with little to no config are enabled here. 
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        # charliermarsh.ruff
        ms-python.python
        # ];
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "roc-lang-unofficial";
          publisher = "ivandemchenko";
          version = "1.2.0";
          sha256 = "sha256-lMN6GlUM20ptg1c6fNp8jwSzlCzE1U0ugRyhRLYGPGE=";
        }
      ];
      userSettings = {
        "editor.fontFamily" = "FiraCode Nerd Font Mono";
        "editor.lineNumbers" = "relative";
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "keyboard.dispatch" = "keyCode";
        "vscode-neovim.neovimClean" = true;
        "window.menuBarVisibility" = "toggle";
        "workbench.startupEditor" = "none";
      };
    };
    zsh = {
      envExtra = ''
        # Add ssh key
        ssh-add "~/.ssh/ssh_id_ed25519_jordan_bravo"
      '';
    };
  };

  services = {
    copyq.enable = true;
  };
}

