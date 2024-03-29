# ~/.nix/shared/linux-home.nix


{ config, pkgs, lib, ... }:

{
  dconf.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [
      adwaita-qt # Adwaita style for Qt apps
      avidemux # Free video editor designed for simple video editing tasks
      bitwarden # Password manager
      brave # Web browser
      # cantarell-fonts # Fonts for waybar
      dino # XMPP client
      distrobox # Run containers of any Linux distro
      docker-compose # Docker Compose plugin for Docker
      # dunst # Notification daemon
      fira-code # Font
      firefox # Web browser
      # font-awesome # Fonts for waybar
      gajim # XMPP client
      # gtklock # Screen lock
      # gtklock-userinfo-module # Screen lock user info
      # glaxnimate # Vector animation program, required for kdenlive
      jdk11 # Java Development Kit
      jitsi-meet # Video calling (not sure if both packages are needed)
      jitsi # Video calling (not sure if both packages are needed)
      killall # Tool to kill processes
      krename # A powerful batch renamer for KDE
      # libsForQt5.kdenlive # Video editor
      nextcloud-client # Nextcloud sync client
      nodejs_20 # NodeJS
      onlyoffice-bin # Office suite
      # openssl # Cryptographic library
      pinta # Image editor
      polkit_gnome # Authentication agent
      # postgresql # SQL database
      spot # Native Spotify client for the GNOME desktop
      standardnotes # Note-taking
      tailscale # Mesh VPN
      telegram-desktop # Messaging client
      thunderbird # Email client
      tor-browser-bundle-bin # Tor browser
      tree # View directory tree structure
      # ulauncher # Application launcher
      vlc # Media player
      # waybar # Status bar
      waypipe # A network proxy for Wayland clients (applications)
      wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
      # wofi # App launcher
      xorg.xwininfo # Display info for X windows and nothing for Wayland windows
      yt-dlp # CLI tool to download YouTube videos
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

    ];
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
  };
  imports = [ ../shared/dconf.nix ../shared/home.nix ../shared/firefox.nix ];
  services = {
    copyq.enable = true;
  };
}
