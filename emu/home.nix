# ~/.setup/tux/home.nix

{ config, pkgs, lib, ... }:

let
  username = "jordan";
  homeDirectory = "/home/${username}";

in
{
  fonts.fontconfig.enable = true;
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    # android-studio # Develop Android apps
    appimage-run # Run AppImages on NixOS
    adwaita-qt # Adwaita style for Qt apps
    bat # Modern replacement for cat
    # bisq-desktop # Decentralized Bitcoin exchange
    # bitwarden # Password manager
    # brave # Web browser
    # cantarell-fonts # Fonts for waybar
    copyq # Clipboard manager
    dconf2nix # Convert dconf settings to nix configs
    dino # XMPP client
    distrobox # Run containers of any Linux distro
    docker-compose # Docker Compose plugin for Docker
    dunst # Notification daemon
    element-desktop # Matrix client
    evolution # Client for calendar, mail, address book
    fira-code # Font
    firefox # Web browser
    # font-awesome # Fonts for waybar
    # freetube # YouTube client
    fzf # Command line fuzzy finder
    gajim # XMPP client
    gcc # Build tool (needed by NeoVim's Treesitter)
    gh # GitHub CLI
    git # Version control
    gnome.dconf-editor # Edit GNOME options
    gnome.gnome-session # GNOME session manager, e.g. `gnome-session-quit`
    gnome.gnome-tweaks # Extra options for GNOME
    # gnome-extension-manager # Manage GNOME extensions
    gnomeExtensions.appindicator # Tray icons
    gnomeExtensions.auto-move-windows # Move applications to specific workspaces when they create windows
    gnomeExtensions.dash-to-dock # Customize the dash
    gnomeExtensions.gsconnect # Transfer files & clipboard across devices
    gnomeExtensions.just-perfection # Customize Gnome shell and UI
    gnomeExtensions.nextcloud-folder # Open Nextcloud folder in one click
    gnomeExtensions.unblank # Keep display on when Gnome locks
    gnomeExtensions.vitals # System info
    gnomeExtensions.space-bar # Adds workspaces to status bar
    gtklock # Screen lock
    gtklock-userinfo-module # Screen lock user info
    # hollywood # Make terminal look like a hollywood hacker terminal
    ivpn # VPN
    ivpn-service # VPN
    jdk11 # Java Development Kit v11
    jitsi-meet # Video calling (not sure if both packages are needed)
    jitsi # Video calling (not sure if both packages are needed)
    jq # JSON processor
    killall # Tool to kill processes
    kitty # Terminal
    gnumake # Build tool (needed by Ruby)
    lsd # The next gen ls command
    lua-language-server # LSP language server for Lua
    luajit # JIT compiler for Lua 5.1
    luajitPackages.luacheck # A static analyzer & linter for Lua
    neovim # Text editor
    nextcloud-client # Nextcloud sync client
    nil # Language server for Nixlang
    nixpkgs-fmt # Formatter for Nixlang
    nodejs_20 # NodeJS 20
    obsidian # Note-taking
    # onlyoffice-bin # Office suite
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
    rustup # Rust toolchain installer. Rust required for Nix language server
    # signal-desktop # Signal desktop
    # slack # Desktop client for Slack
    # sparrow # Bitcoin wallet
    spot # Native Spotify client for the Gnome desktop
    standardnotes # Note-taking
    tailscale # Mesh VPN
    telegram-desktop # Messaging client
    thunderbird # Email client
    # tor-browser-bundle-bin # Tor browser
    trash-cli # CLI trash tool written in Python
    # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
    tree # View directory tree structure
    vlc # Media player
    waybar # Status bar
    wezterm # Terminal emulator
    wget # File retriever
    wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
    wofi # App launcher
    #xdg-desktop-portal-hyprland # Necessary for Hyprland
    xorg.xwininfo # Display info for X windows and nothing for Wayland windows
    yarn # Package manger for JavaScript
    zlib # Build tool (needed by Ruby)
    # zoom-us # Video conferencing
    # zsh-autocomplete # Type-ahead completion
    # zsh-autosuggestions # Based on history
    zsh-powerlevel10k # Zsh prompt theming

  ];
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/j/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "Adwaita:dark";
  };

  dconf.enable = true;
  imports = [ ./dconf.nix ./git.nix ./kitty.nix ./wezterm.nix ./zsh.nix ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg.enable = true;
    #gtklock = {
    #  enable = true;
    #};
    home-manager.enable = true;
    vscode = {
      enable = true;
    };
  };


  # gtk = {
  #   enable = true;
  #   theme.name = "Adwaita-dark";
  # };

  # qt = {
  #   enable = true;
  #   # platformTheme = "gnome";
  #   style.name = "adwaita-dark";
  # };

  services = {
    copyq.enable = true;
    # kdeconnect.enable = true;
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };
}
