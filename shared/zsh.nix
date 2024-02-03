# ~/.nix/shared/zsh.nix
{ pkgs, config, ... }:

{
  programs.zsh = {
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = false;
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

      # If BD NPM token exists, source it
      if [ -f $HOME/bd/.misc/.npm-bd ]; then
        source $HOME/bd/.misc/.npm-bd
      fi

      # Accept next word from zsh autosuggestion with Ctrl+U
      bindkey ^U forward-word

      # Fix bug with up arrow (nixos.wiki/wiki/Zsh)
      bindkey "''${key[Up]}" up-line-or-search

      # Ripgrep config file
      # export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgreprc

      # For Android Development
      # export ANDROID_HOME=$HOME/Android/Sdk
      # export PATH=$PATH:$ANDROID_HOME/emulator
      # export PATH=$PATH:$ANDROID_HOME/platform-tools
      # export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
      # export PATH=$PATH:$ANDROID_HOME/build-tools/33.0.0
      # export PATH=$PATH:$ANDROID_HOME/emulator/bin64
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
      # {
      #   name = "powerlevel10k";
      #   src = pkgs.zsh-powerlevel10k;
      #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # }
    ];
    shellAliases = {
      l = "ls -lAhF";
      la = "ls -AhF";
      hms = "home-manager switch --flake ~/.nix#$(hostname)";
      gexit = "gnome-session-quit --no-prompt";
      nixr = "sudo nixos-rebuild switch --flake ~/.nix";
      s = "git status";
      sauce = "source $HOME/.config/zsh/.zshrc";
      sshk = "kitty +kitten ssh";
      tsd = "sudo tailscale down";
      tse = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true";
      tsu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false";
      tss = "tailscale status";
      vim = "nvim";
      waybarc = "vim ~/.config/waybar/config.jsonc";
      waybars = "vim ~/.config/waybar/style.css";
      yubi-add = "ssh-add -s /usr/local/lib/libykcs11.dylib";
    };
    syntaxHighlighting = {
      enable = true;
    };
  };
}
