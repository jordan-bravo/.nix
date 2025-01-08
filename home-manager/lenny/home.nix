# lenny/home.nix

{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home = {
    # file = {
    #   gpg-agent = {
    #     target = ".gnupg/gpg-agent.conf";
    #     enable = false;
    #     text = ''
    #       pinentry-program ${config.home.homeDirectory}/.nix-profile/bin/pinentry-curses
    #     '';
    #   };
    # };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      brightnessctl # Read and control device brightness
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
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    sessionVariables = {
      EDITOR = "nvim";
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
  systemd.user.services = {
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


