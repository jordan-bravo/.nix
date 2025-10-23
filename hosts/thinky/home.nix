{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;
  home = {
    packages = with pkgs; [
      ### fonts
      nerd-fonts.fira-code # Nerd Fonts: Programming ligatures, extension of Fira Mono font, enlarged operators

      # adwaita-qt # Adwaita style for Qt apps
      # adwaita-qt6 # Adwaita style for Qt6 apps
      awscli2 # Unified tool to manage your AWS services
      # beekeeper-studio # SQL client
      bitcoind # Bitcoin core
      # blueman # GTK-based Bluetooth Manager
      # brightnessctl # Read and control device brightness
      ccls # C/c++ language server powered by clang
      # clang # C language family frontend for LLVM
      curl # Command line tool for transferring files with URL syntax
      duf # Disk Usage/Free Utility
      evil-helix # Helix editor with vim keybindings
      fontconfig
      fd # Simple, fast and user-friendly alternative to find
      fnm # Fast and simple Node.js version manager
      # gcc # GNU compiler collection
      # gcr # GNOME crypto services (daemon and tools), required for gpg pinentry-gnome3
      gh # GitHub CLI
      ghostty # Fast, native, feature-rich terminal emulator pushing modern features
      heroku # Heroku CLI
      git-crypt # Transparent file encryption in git
      grim # Grab images from a Wayland compositor
      hello # CLI hello world
      kanata # Tool to improve keyboard comfort and usability with advanced customization
      # kdePackages.qt6ct # Qt6 Configuration Tool
      lazydocker # Simple terminal UI for both docker and docker-compose
      lazygit # Simple terminal UI for git commands
      # libsForQt5.qt5.qtwayland # Cross-platform app framework for C++
      # libsForQt5.qt5ct # Qt5 Configuration Tool
      meson # Open source, fast and friendly build system made in Python
      # nautilus # File manager for GNOME
      neovim # Text editor / IDE
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      # nodejs-14.nodejs-14_x # NodeJS 14
      openssh # Implementation of the SSH protocol
      # pamixer # Pulseaudio command line mixer
      pinentry-gnome3 # GnuPG’s interface to passphrase input
      # postman # API client
      procs # Modern ps
      rustlings # Explore the Rust programming language and learn more about it while doing exercises
      sd # Intuitive find & replace CLI (sed alternative)
      # seahorse # Application for managing encryption keys and passwords in the GnomeKeyring
      # slurp # Select a region of the screen in a Wayland compositor
      somo # Socket and port monitoring tool (replacement for ss)
      sparrow # Modern desktop Bitcoin wallet application
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      # swayosd # on screen display for keyboard shortcuts such as volume and brightness
      terraform # Tool for building, changing, and versioning infrastructure
      terraform-ls # Terraform Language Server (official)
      tldr # Simplified and community-driven man pages
      trash-cli # Command line interface to the freedesktop.org trashcan
      waypipe # Network proxy for Wayland clients (applications)
      wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
      xdg-utils # Tools that assist applications with a variety of desktop integration tasks
      xorg.xlsclients # Lists any applications running under Xwayland

      # Programming language tools
      python312Packages.python-lsp-server
    ];
    homeDirectory = "/home/${config.home.username}";
    preferXdgDirectories = true;
    sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" "/run/system-manager/sw/bin" ];
    sessionVariables = {
      # _JAVA_AWT_WM_NONREPARENTING = 1;
      DOCKER_CONFIG = "$HOME/.config/docker";
      EDITOR = "nvim";
      GTK_THEME = "Adwaita:dark";
      LESSHISTFILE = "$XDG_STATE_HOME/less/history";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "adwaita-dark";
      QT_STYLE_OVERRIDE = "adwaita-dark";
      # SDL_VIDEODRIVER = "wayland";
      TZ = "America/New_York";
      # XDG_CURRENT_DESKTOP = "sway";
      # XDG_SESSION_DESKTOP = "sway";
      # XDG_SESSION_TYPE = "wayland";
    };
    stateVersion = "25.05";
    username = "jordan";
  };
  imports = [
    ../../modules/home-manager/delta.nix
    ../../modules/home-manager/git.nix
    # ../../modules/home-manager/i3status.nix
    # ../../modules/home-manager/kanata.nix
    # ../../modules/home-manager/kanshi.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/nvim-deps.nix
    ../../modules/home-manager/ripgrep.nix
    ../../modules/home-manager/workstation-secrets.nix
    # ../../modules/home-manager/zellij.nix
    ../../modules/home-manager/zsh.nix
  ];
  programs = {
    atuin.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "Visual Studio Dark+";
      };
    };
    bottom.enable = true;
    broot.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      silent = true;
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
      enableDefaultConfig = false;
      matchBlocks."*".addKeysToAgent = "yes";
      matchBlocks."*".forwardAgent = true;
      extraConfig = ''
        StrictHostKeyChecking=no
      '';
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
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
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      initContent = ''
        # start ssh agent and add key to agent
        eval "$(ssh-agent)" > /dev/null
        ssh-add -q ~/.ssh/ssh_id_ed25519_jordan_bravo

        # If BD NPM token exists, source it
        if [ -f $HOME/bd/.misc/.npm-bd ]; then
          source $HOME/bd/.misc/.npm-bd
        fi

        # these are set on nixos, so need to be set on non-nixos

        # If bat exists, use instead of cat
        type bat > /dev/null 2>&1 && alias cat=bat

        # If lsd exists, use instead of ls
        type lsd > /dev/null 2>&1 && alias ls=lsd

        # If zoxide exists, use instead of cd
        type zoxide > /dev/null 2>&1 && alias cd=z

        # If ripgrep exists, use instead of grep
        type rg > /dev/null 2>&1 && alias grep=rg

        # If fd exists, use instead of find
        type fd > /dev/null 2>&1 && alias find=fd

        # If duf exists, use instead of df
        type duf > /dev/null 2>&1 && alias df=duf

        # If dust exists, use instead of du
        type dust > /dev/null 2>&1 && alias du=dust

        # Accept next word from zsh autosuggestion with Ctrl+U
        bindkey ^U forward-word

        # Disable git pull
        git() { if [[ $@ == "pull" ]]; then command echo "git pull disabled.  Use git fetch + git merge."; else command git "$@"; fi; }

      '';
      # profileExtra = ''
      #   # automatically start sway
      #   if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
      #       exec sway
      #   fi
      # '';
      shellAliases = {
        l = "ls -lAhF";
        lal = "ls -AhF";
        d = "docker";
        dc = "docker compose";
        gad = "git add";
        gcm = "git commit";
        gdi = "git diff";
        gfe = "git fetch";
        gme = "git merge";
        gpu = "git push";
        grb = "git rebase";
        grs = "git restore";
        gsw = "git switch";
        gsh = "git stash";
        gsu = "git status";
        hms = "home-manager switch --flake ~/.nix#$(hostname)";
        mise-activate = "eval \"$(~/.local/bin/mise activate zsh)\"";
        nr = "sudo nixos-rebuild switch --flake ~/.nix";
        sauce = "source $HOME/.config/zsh/.zshrc";
        sshk = "kitty +kitten ssh";
        td = "sudo tailscale down";
        te = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true --accept-dns=false --operator=$USER";
        tu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false --accept-dns=false --operator=$USER";
        ts = "tailscale status";
        v = "nvim";

        # Connect to machines on tailnet
        finserv = "ssh main@$(tailscale status | grep finserv | awk '{print $1}')";
        medserv = "ssh main@$(tailscale status | grep medserv | awk '{print $1}')";
        punk-ubuntu = "ssh main@$(tailscale status | grep punk-ubuntu | awk '{print $1}')";
        sovserv = "ssh main@$(tailscale status | grep sovserv | awk '{print $1}')";
      };
    };
  };

  services = {
    copyq.enable = true;
    gnome-keyring = {
      enable = false;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      maxCacheTtl = 4;
      pinentry.package = pkgs.pinentry-gnome3;
      verbose = true;
    };
    udiskie = {
      enable = true;
      tray = "never";
    };
  };
  # systemd.user.targets = {
  #   sway-session = {
  #     Unit = {
  #       Description = "sway compositor session";
  #       Documentation = "man:systemd.special(7)";
  #       BindsTo = "graphical-session.target";
  #       Wants = "graphical-session-pre.target";
  #       After = "graphical-session-pre.target";
  #     };
  #   };
  # };
  targets.genericLinux.enable = true;
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    desktopEntries = {
      cursor = {
        name = "Cursor Editor";
        genericName = "Editor";
        comment = "AI Powered Code Editor";
        exec = "${config.home.homeDirectory}/apps/cursor/run-cursor.sh";
      };
      # ghostty = {
      #   name = "Ghostty";
      #   genericName = "Terminal Emulator";
      #   comment = "Fast, native, feature-rich terminal emulator pushing modern features";
      #   exec = "nixGLIntel ghostty";
      #   icon = "ghostty";
      #   categories = [ "System" "TerminalEmulator" ];
      # };
      kitty = {
        name = "Kitty";
        genericName = "Terminal Emulator";
        comment = "Fast, feature-rich, GPU based terminal";
        exec = "nixGLIntel kitty";
        icon = "kitty";
        categories = [ "System" "TerminalEmulator" ];
      };
      sparrow-desktop = {
        name = "Sparrow Testnet";
        genericName = "Bitcoin wallet";
        exec = "sparrow-desktop --network testnet";
        icon = "sparrow-desktop";
        categories = [ "Finance" ];
        mimeType = [ "application/psbt" ];
      };
    };
    # Add diretories to XDG_DATA_DIRS
    systemDirs.data = [ "${config.home.homeDirectory}/.local/share/flatpak/exports/share" ];
  };

  home.file = {
    dino-font-size-config = {
      target = ".var/app/im.dino.Dino/config/gtk-4.0/gtk.css";
      enable = true;
      text = ''
        @import "colors.css";
        window.dino-main {
          font-size: 26px;
        }

        window.dino-main .dino-conversation {
          font-size: 26px;
        }
      '';
    };
    ghostty-config = {
      target = ".config/ghostty/config";
      enable = false;
      text = ''
        background = 222222
        font-family = Fira Code
        font-size = 14
        window-decoration = false
      '';
    };
    vimrc = {
      target = ".vimrc";
      enable = true;
      text = ''
        autocmd InsertEnter * set nu nornu
        autocmd InsertLeave * set nu rnu
      '';
    };
    # nextcloud-desktop-entry = {
    #   target = ".local/share/applications/com.nextcloud.desktopclient.nextcloud.desktop";
    #   enable = true;
    #   text = ''
    #     [Desktop Entry]
    #     Categories=Utility;X-SuSE-SyncUtility;
    #     Type=Application
    #     Exec=flatpak run com.nextcloud.desktopclient.nextcloud
    #     Name=Nextcloud Desktop
    #     Comment=Nextcloud desktop synchronization client
    #     GenericName=Folder Sync
    #     Icon=com.nextcloud.desktopclient.nextcloud
    #     Keywords=Nextcloud;syncing;file;sharing;
    #     X-GNOME-Autostart-Delay=3
    #     MimeType=application/vnd.nextcloud;x-scheme-handler/nc;
    #     SingleMainWindow=true
    #     Actions=Quit;
    #     Implements=org.freedesktop.CloudProviders
    #     X-Flatpak=com.nextcloud.desktopclient.nextcloud
    #
    #     [org.freedesktop.CloudProviders]
    #     BusName=com.nextcloudgmbh.Nextcloud
    #     ObjectPath=/com/nextcloudgmbh/Nextcloud
    #     Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 com.nextcloud.desktopclient.nextcloud
    #
    #     [Desktop Action Quit]
    #     Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=nextcloud com.nextcloud.desktopclient.nextcloud --quit
    #     Name=Quit Nextcloud
    #     Icon=nextcloud
    #   '';
    # };
    # signal-desktop-entry = {
    #   target = ".local/share/applications/org.signal.Signal.desktop";
    #   enable = true;
    #   text = ''
    #     [Desktop Entry]
    #     Name=Signal
    #     Exec=flatpak run org.signal.Signal --use-tray-icon --no-sandbox %U --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland
    #     Terminal=false
    #     Type=Application
    #     Icon=org.signal.Signal
    #     StartupWMClass=Signal
    #     Comment=Private messaging from your desktop
    #     MimeType=x-scheme-handler/sgnl;x-scheme-handler/signalcaptcha;
    #     Categories=Network;InstantMessaging;Chat;
    #     X-Desktop-File-Install-Version=0.28
    #     X-Flatpak-RenamedFrom=signal-desktop.desktop;
    #     X-Flatpak=org.signal.Signal
    #   '';
    # };
    # trayscale-desktop-entry = {
    #   target = ".local/share/applications/dev.deedles.Trayscale.desktop";
    #   enable = true;
    #   text = ''
    #     [Desktop Entry]
    #     Version=1.0
    #     Type=Application
    #     Name=Trayscale
    #     GenericName=Tailscale Client
    #     Comment=An unofficial GUI interface for the Tailscale daemon.
    #     Categories=System;GNOME;GTK;
    #     Keywords=tailscale;vpn;
    #     Icon=dev.deedles.Trayscale
    #     Exec=flatpak run dev.deedles.Trayscale --hide-window
    #     Terminal=false
    #     SingleMainWindow=true
    #     X-GNOME-UsesNotifications=true
    #     X-Flatpak=dev.deedles.Trayscale
    #   '';
    # };
  };
}
