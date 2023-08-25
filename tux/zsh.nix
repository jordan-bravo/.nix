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
      cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      s = "git status";
      cs = "cfg status";
      l = "ls -lAhF";
      la = "ls -AhF";
      htux = "cd ~/.setup/tux && nvim ~/.setup/tux/home.nix";
      hypc = "nvim ~/.config/hypr/hyprland.conf";
      kitc = "nvim ~/.config/kitty/kitty.conf";
      kits = "nvim ~/.config/kitty/session.conf";
      gexit = "gnome-session-quit --no-prompt";
      nixr = "sudo nixos-rebuild switch --flake ~/.nix";
      notify-piano = "play ~/Documents/piano.wav";
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
