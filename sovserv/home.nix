# ~/.nix/sovserv/home.nix

{ config, pkgs, lib, ... }:

{

  home = {
    packages = with pkgs; [
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "23.11";
  };

  programs = {
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
      };
    };
    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font Mono";
      };
    };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
  };

  services = {
    copyq.enable = false;
  };

  programs = {
    starship = {
      enable = true;
      settings = {
        directory = {
          truncate_to_repo = false;
        };
        gcloud = {
          disabled = true;
        };
      };
    };
    zsh = {
      defaultKeymap = "viins";
      dotDir = ".config/zsh";
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      history = {
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };
      envExtra = ''
        export LESSUTFCHARDEF=e000-f8ff:p,f0000-10ffff:p
        export QT_STYLE_OVERRIDE="adwaita-dark"
      '';
      initExtra = ''
        # If bat exists, use instead of cat
        type bat > /dev/null 2>&1 && alias cat=bat

        # If lsd exists, use instead of ls
        type lsd > /dev/null 2>&1 && alias ls=lsd

        # Keep prompt at bottom of terminal window
        printf '\n%.0s' {1..$LINES}
      '';
      plugins = [
        {
          name = "zsh-autocomplete";
          src = pkgs.fetchFromGitHub {
            owner = "marlonrichert";
            repo = "zsh-autocomplete";
            rev = "23.07.13";
            sha256 = "0NW0TI//qFpUA2Hdx6NaYdQIIUpRSd0Y4NhwBbdssCs=";
          };
        }
      ];
      shellAliases = {
        l = "ls -lAhF";
        la = "ls -AhF";
        hms = "home-manager switch --flake ~/server-conf#$(hostname)";
        nixr = "sudo nixos-rebuild switch --flake ~/server-conf#$(hostname)";
        s = "git status";
        tsd = "sudo tailscale down";
        tse = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true";
        tsu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false";
        tss = "tailscale status";
        vim = "nvim";
      };
      syntaxHighlighting = {
        enable = true;
      };
    };
  };
}
