# ~/.nix/tux/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
  homeDirectory = "/home/${username}";

in
{
  home = {
    homeDirectory = homeDirectory;
    username = username;
    packages = with pkgs; [
      android-studio # Develop Android apps
      appimage-run # Run AppImages on NixOS
      adwaita-qt # Adwaita style for Qt apps
      bisq-desktop # Decentralized Bitcoin exchange
      bitwarden # Password manager
      brave # Web browser
      # cantarell-fonts # Fonts for waybar
      dino # XMPP client
      distrobox # Run containers of any Linux distro
      docker-compose # Docker Compose plugin for Docker
      dunst # Notification daemon
      element-desktop # Matrix client
      evolution # Client for calendar, mail, address book
      fira-code # Font
      firefox # Web browser
      # font-awesome # Fonts for waybar
      freetube # YouTube client
      gajim # XMPP client
      gcc # Build tool (needed by NeoVim's Treesitter)
      # git # Version control
      gnome.dconf-editor # Edit GNOME options
      gnome.gnome-session # GNOME session manager, e.g. `gnome-session-quit`
      gnome.gnome-tweaks # Extra options for GNOME
      gnome-extension-manager # Manage GNOME extensions
      gnomeExtensions.appindicator # Tray icons
      gnomeExtensions.auto-move-windows # Move applications to specific workspaces when they create windows
      gnomeExtensions.dash-to-dock # Customize the dash
      gnomeExtensions.gsconnect # Transfer files & clipboard across devices
      gnomeExtensions.just-perfection # Customize Gnome shell and UI
      gnomeExtensions.nextcloud-folder # Open Nextcloud folder in one click
      gnomeExtensions.unblank # Keep display on when Gnome locks
      gnomeExtensions.vitals # System info
      gnomeExtensions.space-bar # Adds workspaces to status bar
      gnumake # Build tool (needed by Ruby)
      # gtklock # Screen lock
      gtklock-userinfo-module # Screen lock user info
      # hollywood # Make terminal look like a hollywood hacker terminal
      # ivpn # VPN
      # ivpn-service # VPN
      jdk11 # Java Development Kit v11
      jitsi-meet # Video calling (not sure if both packages are needed)
      jitsi # Video calling (not sure if both packages are needed)
      killall # Tool to kill processes
      # kitty # Terminal
      lua-language-server # LSP language server for Lua
      luajit # JIT compiler for Lua 5.1
      luajitPackages.luacheck # A static analyzer & linter for Lua
      nextcloud-client # Nextcloud sync client
      nodejs_20 # NodeJS 20
      obsidian # Note-taking
      onlyoffice-bin # Office suite
      openssl # Cryptographic library
      pinta # Image editor
      polkit_gnome # Authentication agent
      postman # API development environment
      postgresql # SQL database
      nodePackages.prettier # Code formatter for HTML/CSS/JS
      prettierd # Prettier daemon for improved performance
      pyright # Static type checker for Python
      python311 # Python 3.11
      python311Packages.pip # Tool for installing Python packages
      ripgrep # Search tool
      ruby_3_2 # Ruby language
      signal-desktop # Signal desktop
      slack # Desktop client for Slack
      sparrow # Bitcoin wallet
      spot # Native Spotify client for the Gnome desktop
      standardnotes # Note-taking
      tailscale # Mesh VPN
      telegram-desktop # Messaging client
      thunderbird # Email client
      tor-browser-bundle-bin # Tor browser
      tree # View directory tree structure
      # ulauncher # Application launcher
      vlc # Media player
      waybar # Status bar
      wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
      wofi # App launcher
      #xdg-desktop-portal-hyprland # Necessary for Hyprland
      xorg.xwininfo # Display info for X windows and nothing for Wayland windows
      yarn # Package manger for JavaScript
      zlib # Build tool (needed by Ruby)
      zoom-us # Video conferencing
    ];
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    stateVersion = "23.05";
  };

  dconf.enable = true;
  imports = [ ../shared/home.nix ];

  services = {
    copyq.enable = true;
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };
}
