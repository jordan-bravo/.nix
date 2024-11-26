# shared/zsh.nix
{ config, ... }:

{
  programs.zsh = {
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    enable = true;
    autosuggestion.enable = true;
    # enableCompletion = true;
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
      # if [ -f $HOME/bd/.misc/.npm-bd ]; then
      #   source $HOME/bd/.misc/.npm-bd
      # fi

      # Accept next word from zsh autosuggestion with Ctrl+U
      bindkey ^U forward-word

      # Add cargo binary directory to PATH
      export PATH=$PATH:$HOME/.cargo/bin

      # Ripgrep config file
      # export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgreprc

      # For Android Development
      export ANDROID_HOME=$HOME/Android/Sdk
      export PATH=$PATH:$ANDROID_HOME/emulator
      export PATH=$PATH:$ANDROID_HOME/platform-tools
      # export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
      # export PATH=$PATH:$ANDROID_HOME/build-tools/33.0.0
      # export PATH=$PATH:$ANDROID_HOME/emulator/bin64

      # Disable git pull
      git() { if [[ $@ == "pull" ]]; then command echo "git pull disabled.  Use git fetch + git merge."; else command git "$@"; fi; }
    '';
    # plugins = [
    #   # {
    #   #   name = "zsh-autocomplete";
    #   #   src = pkgs.fetchFromGitHub {
    #   #     owner = "marlonrichert";
    #   #     repo = "zsh-autocomplete";
    #   #     rev = "23.07.13";
    #   #     sha256 = "0NW0TI//qFpUA2Hdx6NaYdQIIUpRSd0Y4NhwBbdssCs=";
    #   #   };
    #   # }
    #   # {
    #   #   name = "powerlevel10k";
    #   #   src = pkgs.zsh-powerlevel10k;
    #   #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   # }
    # ];
    shellAliases = {
      l = "ls -lAhF";
      la = "ls -AhF";
      gexit = "gnome-session-quit --no-prompt";
      hms = "home-manager switch --flake ~/.nix#$(hostname)";
      jv = "NVIM_APPNAME=jvim nvim";
      jvim = "NVIM_APPNAME=jvim nvim";
      mise-activate = "eval \"$(~/.local/bin/mise activate zsh)\"";
      nr = "sudo nixos-rebuild switch --flake ~/.nix";
      s = "git status";
      sauce = "source $HOME/.config/zsh/.zshrc";
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
    syntaxHighlighting = {
      enable = true;
    };
  };
}

