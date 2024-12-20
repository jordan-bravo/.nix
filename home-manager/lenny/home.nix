# lenny/home.nix

{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home = {
    file = {
      gpg-agent = {
        target = ".gnupg/gpg-agent.conf";
        enable = true;
        text = ''
          pinentry-program ${config.home.homeDirectory}/.nix-profile/bin/pinentry-curses
        '';
      };
    };
    packages = with pkgs; [
      git-crypt # Transparent file encryption in git
      kanata # Tool to improve keyboard comfort and usability with advanced customization
      neovim # Text editor / IDE
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      pinentry-curses # GnuPG’s interface to passphrase input
      pamixer # Pulseaudio command line mixer
      udiskie # Removable disk automounter for udisks
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
    # ../shared/fuzzel.nix
    ../shared/git.nix
    # ../shared/home.nix
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
    atuin = {
      enable = true;
      settings = {
        enter_accept = false;
      };
    };
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
    gh.enable = true;
    git.enable = true;
    # gpg.enable = true;
    home-manager.enable = true;
    i3status-rust.enable = true;
    jq.enable = true;
    lsd.enable = true;
    mise.enable = false;
    ssh = {
      enable = true;
      # extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
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
    wofi = {
      enable = true;
    };
    # yazi = {
    #   enable = true; # disabled because broken by latest update to nixpkgs on Nov 3rd
    #   enableZshIntegration = true;
    # };
    # zoxide = {
    #   enable = true;
    # };
  };
  # programs.zsh.initExtra = ''
  #   # Add ssh key, suppress output
  #   ssh-add "$HOME/.ssh/ssh_id_ed25519_jordan@bravo"
  #   # Mise
  #   # export PATH=$HOME/.local/bin:$PATH
  #   # eval "$(mise activate zsh)"
  # '';

  # services = {
  #   copyq.enable = true;
  # };
  targets.genericLinux.enable = true;
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };
}


