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
      git # Distributed version control system
      git-crypt # Transparent file encryption in git
      kanata # Tool to improve keyboard comfort and usability with advanced customization
      neovim # Text editor / IDE
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      pinentry-curses # GnuPG’s interface to passphrase input
      udiskie # Removable disk automounter for udisks
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
    # ../shared/fuzzel.nix
    ../shared/git.nix
    # ../shared/home.nix
    # ../shared/kanata.nix
    ../shared/kanshi.nix
    ../shared/nvim/deps.nix
    ../shared/ripgrep.nix
    # ../shared/workstations.nix
    ../../secrets/workstations-secrets.nix
    # ../shared/zellij.nix
    # ../shared/zsh.nix
  ];
  # nixpkgs.config.allowUnfree = true;
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
    bash = {
      enable = true;
      enableCompletion = true;
      # bashrcExtra = ''
      #   # Add ssh key, suppress output
      #   ssh-add "$HOME/.ssh/ssh_id_ed25519_jordan@bravo" 1> /dev/null 2>&1
      # '';
      historyControl = [ "erasedups" ];
      shellAliases = {
        gexit = "gnome-session-quit --no-prompt";
        hms = "home-manager switch --flake ~/.nix#$(hostname)";
        jv = "NVIM_APPNAME=jvim nvim";
        jvim = "NVIM_APPNAME=jvim nvim";
        l = "ls -hAlF";
        ll = "ls -hlF";
        la = "ls -hAF";
        mise-activate = "eval \"$(~/.local/bin/mise activate zsh)\"";
        nr = "sudo nixos-rebuild switch --flake ~/.nix";
        s = "git status";
        sc = "v ~/.config/sway/config";
        sshk = "kitty +kitten ssh";
        td = "sudo tailscale down";
        te = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true --accept-dns=false --operator=$USER";
        tu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false --accept-dns=false --operator=$USER";
        ts = "tailscale status";
        v = "nvim";
        waybarc = "nvim ~/.config/waybar/config.jsonc";
        waybars = "nvim ~/.config/waybar/style.css";
        yubi-add = "ssh-add -s /usr/local/lib/libykcs11.dylib";

        # Connect to machines on tailnet
        medserv = "waypipe ssh main@$(tailscale status | grep medserv | awk '{print $1}')";
        finserv = "waypipe ssh main@$(tailscale status | grep finserv | awk '{print $1}')";
        sovserv = "waypipe ssh main@$(tailscale status | grep sovserv | awk '{print $1}')";
      };
    };
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
    # gpg.enable = true;
    home-manager.enable = true;
    i3status-rust = {
      enable = true;
      bars.default = {
        blocks = [
          {
            block = "battery";
          }
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon mem_used_percents ";
            format_alt = " $icon $swap_used_percents ";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            format = " $icon $1m ";
            interval = 1;
          }
          {
            block = "sound";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            interval = 60;
          }
        ];
      };
    };
    jq.enable = true;
    lsd.enable = true;
    mise.enable = false;
    # ssh = {
    #   enable = true;
    #   # extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
    #   addKeysToAgent = "yes";
    #   # extraConfig = ''
    #   #   IdentityFile ~/.ssh/ssh_id_ed25519_jordan_bravo
    #   #   IdentitiesOnly yes
    #   # '';
    # };
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


