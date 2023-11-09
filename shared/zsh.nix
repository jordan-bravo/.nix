# ~/.nix/shared/zsh.nix
{ pkgs, ... }:

{
  programs.zsh = {
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    initExtra = ''
      # If bat exists, use instead of cat
      type bat > /dev/null 2>&1 && alias cat=bat

      # If lsd exists, use instead of ls
      type lsd > /dev/null 2>&1 && alias ls=lsd

      # Keep prompt at bottom of terminal window
      printf '\n%.0s' {1..$LINES}

      # If BD NPM token exists, source it
      if [ -f $HOME/bd/.misc/.bd-npm ]; then
        source $HOME/bd/.misc/.bd-npm
      fi
    '';
    localVariables = {
      PATH = "/opt/homebrew/bin:$PATH";
    };
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
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = ".p10k.zsh";
      }
    ];
    shellAliases = {
      darr = "darwin-rebuild switch --flake ~/.nix";
      l = "ls -lAhF";
      la = "ls -AhF";
      hypc = "nvim ~/.config/hypr/hyprland.conf";
      gexit = "gnome-session-quit --no-prompt";
      nixr = "sudo nixos-rebuild switch --flake ~/.nix";
      notify-piano = "play ~/Documents/piano.wav";
      s = "git status";
      sauce = "source $HOME/.config/zsh/.zshrc";
      sshk = "kitty +kitten ssh";
      vim = "nvim";
      waybarc = "nvim ~/.config/waybar/config.jsonc";
      waybars = "nvim ~/.config/waybar/style.css";
      yubi-add = "ssh-add -s /usr/local/lib/libykcs11.dylib";
    };
    syntaxHighlighting = {
      enable = true;
    };
  };
}
