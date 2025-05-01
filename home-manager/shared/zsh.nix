# shared/zsh.nix
{ config, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "brackets" ];
    # autosuggestion.enable = true;
    # enableCompletion = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    # envExtra = ''
    #   export LESSUTFCHARDEF=e000-f8ff:p,f0000-10ffff:p
    # '';
    initExtra = ''
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

      # If BD NPM token exists, source it
      if [ -f $HOME/bd/.misc/.npm-bd ]; then
        source $HOME/bd/.misc/.npm-bd
      fi

      # Keep prompt at bottom of terminal window
      # printf '\n%.0s' {1..$LINES}

      # Accept next word from zsh autosuggestion with Ctrl+U
      bindkey ^U forward-word

      # Disable git pull
      git() { if [[ $@ == "pull" ]]; then command echo "git pull disabled.  Use git fetch + git merge."; else command git "$@"; fi; }
    '';
    profileExtra = ''
      # automatically start sway
      if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
          exec sway
      fi
    '';
    shellAliases = {
      l = "ls -lAhF";
      lal = "ls -AhF";
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

      # Connect to machines on tailnet
      medserv = "waypipe ssh main@$(tailscale status | grep medserv | awk '{print $1}')";
      finserv = "waypipe ssh main@$(tailscale status | grep finserv | awk '{print $1}')";
      sovserv = "waypipe ssh main@$(tailscale status | grep sovserv | awk '{print $1}')";
    };
  };
}
