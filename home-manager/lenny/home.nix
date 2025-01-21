# lenny/home.nix

{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home = {
    file = {
      trayscale-desktop-entry = {
        target = ".local/share/applications/dev.deedles.Trayscale.desktop";
        enable = true;
        text = ''
          [Desktop Entry]
          Version=1.0
          Type=Application
          Name=Trayscale
          GenericName=Tailscale Client
          Comment=An unofficial GUI interface for the Tailscale daemon.
          Categories=System;GNOME;GTK;
          Keywords=tailscale;vpn;
          Icon=dev.deedles.Trayscale
          Exec=flatpak run dev.deedles.Trayscale --hide-window
          Terminal=false
          SingleMainWindow=true
          X-GNOME-UsesNotifications=true
          X-Flatpak=dev.deedles.Trayscale
        '';
      };
      nextcloud-desktop-entry = {
        target = ".local/share/applications/com.nextcloud.desktopclient.nextcloud.desktop";
        enable = true;
        text = ''
          [Desktop Entry]
          Categories=Utility;X-SuSE-SyncUtility;
          Type=Application
          Exec=flatpak run com.nextcloud.desktopclient.nextcloud
          Name=Nextcloud Desktop
          Comment=Nextcloud desktop synchronization client
          GenericName=Folder Sync
          Icon=com.nextcloud.desktopclient.nextcloud
          Keywords=Nextcloud;syncing;file;sharing;
          X-GNOME-Autostart-Delay=3
          MimeType=application/vnd.nextcloud;x-scheme-handler/nc;
          SingleMainWindow=true
          Actions=Quit;
          Implements=org.freedesktop.CloudProviders
          X-Flatpak=com.nextcloud.desktopclient.nextcloud

          [org.freedesktop.CloudProviders]
          BusName=com.nextcloudgmbh.Nextcloud
          ObjectPath=/com/nextcloudgmbh/Nextcloud
          Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 com.nextcloud.desktopclient.nextcloud

          [Desktop Action Quit]
          Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=nextcloud com.nextcloud.desktopclient.nextcloud --quit
          Name=Quit Nextcloud
          Icon=nextcloud
        '';
      };
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      brightnessctl # Read and control device brightness
      ccls # C/c++ language server powered by clang
      clang # C language family frontend for LLVM
      curl # Command line tool for transferring files with URL syntax
      fd # Simple, fast and user-friendly alternative to find
      gcr # GNOME crypto services (daemon and tools), required for gpg pinentry-gnome3
      gh # GitHub CLI
      git-crypt # Transparent file encryption in git
      grim # Grab images from a Wayland compositor
      kanata # Tool to improve keyboard comfort and usability with advanced customization
      nautilus # File manager for GNOME
      neovim # Text editor / IDE
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      openssh # Implementation of the SSH protocol
      pinentry-gnome3 # GnuPG’s interface to passphrase input
      pamixer # Pulseaudio command line mixer
      sd # Intuitive find & replace CLI (sed alternative)
      seahorse # Application for managing encryption keys and passwords in the GnomeKeyring
      slurp # Select a region in a Wayland compositor
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      trash-cli # Command line interface to the freedesktop.org trashcan
      waypipe # Network proxy for Wayland clients (applications)
      wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
    ];
    homeDirectory = "/home/${config.home.username}";
    preferXdgDirectories = true;
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = 1;
      EDITOR = "nvim";
      GTK_THEME = "Adwaita:dark";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORM_THEME = "adwaita-dark";
      QT_STYLE_OVERRIDE = "adwaita-dark";
      SDL_VIDEODRIVER = "wayland";
      TZ = "America/New_York";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };
    stateVersion = "24.11";
    username = "jordan";
  };
  imports = [
    ../shared/bash.nix
    ../shared/git.nix
    ../shared/i3status.nix
    # ../shared/kanata.nix
    ../shared/kanshi.nix
    ../shared/nvim/deps.nix
    ../shared/ripgrep.nix
    # ../shared/workstations.nix
    ../../secrets/workstations-secrets.nix
    # ../shared/zellij.nix
    # ../shared/zsh.nix
  ];
  # programs.zsh.profileExtra = ''
  #   export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
  # '';
  programs = {
    atuin.enable = true;
    # atuin.settings.enter_accept = false;
    bash.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "Visual Studio Dark+";
      };
    };
    broot.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    fuzzel.enable = true;
    # gh.enable = true;
    git.enable = true;
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
    home-manager.enable = true;
    i3status-rust.enable = true;
    jq.enable = true;
    lsd.enable = true;
    mise.enable = false;
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        StrictHostKeyChecking=no
      '';
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        directory = {
          truncation_length = 8;
          truncation_symbol = ".../";
          repo_root_style = "purple";
        };
        gcloud = {
          disabled = true;
        };
      };
    };
    waybar.enable = true;
    yazi = {
      enable = true;
      enableBashIntegration = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  services = {
    # copyq.enable = true;
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      maxCacheTtl = 4;
      pinentryPackage = pkgs.pinentry-gnome3;
      verbose = true;
    };
    udiskie = {
      enable = true;
      tray = "never";
    };
  };
  systemd.user.targets = {
    sway-session = {
      Unit = {
        Description = "sway compositor session";
        Documentation = "man:systemd.special(7)";
        BindsTo = "graphical-session.target";
        Wants = "graphical-session-pre.target";
        After = "graphical-session-pre.target";
      };
    };
  };
  targets.genericLinux.enable = true;
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };
}


