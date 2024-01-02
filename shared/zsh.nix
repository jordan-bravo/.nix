# ~/.nix/shared/zsh.nix
{ pkgs, config, ... }:

{
  programs.zsh = {
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

      # If BD NPM token exists, source it
      if [ -f $HOME/bd/.misc/.npm-bd ]; then
        source $HOME/bd/.misc/.npm-bd
      fi

      # Ripgrep config file
      export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgreprc

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
      darr = "darwin-rebuild switch --flake ~/.nix";
      l = "ls -lAhF";
      la = "ls -AhF";
      hmr = "home-manager switch --flake ~/.nix";
      hypc = "vim ~/.config/hypr/hyprland.conf";
      gexit = "gnome-session-quit --no-prompt";
      nixr = "sudo nixos-rebuild switch --flake ~/.nix";
      notify-piano = "play ~/Documents/piano.wav";
      s = "git status";
      sauce = "source $HOME/.config/zsh/.zshrc";
      sshk = "kitty +kitten ssh";
      tur="sudo tailscale up --reset";
      tuv="sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true";
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
