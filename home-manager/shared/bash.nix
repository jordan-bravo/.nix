{
  programs.bash = {
    enableCompletion = true;
    historyControl = [ "erasedups" ];
    bashrcExtra = ''
      # If bat exists, use instead of cat
      type bat > /dev/null 2>&1 && alias cat=bat

      # If lsd exists, use instead of ls
      type lsd > /dev/null 2>&1 && alias ls=lsd

      # If zoxide exists, use instead of cd
      type zoxide > /dev/null 2>&1 && alias cd=z

      # If BD NPM token exists, source it
      if [ -f $HOME/bd/.misc/.npm-bd ]; then
        source $HOME/bd/.misc/.npm-bd
      fi

      # autocomplete
      bind 'TAB:menu-complete'
      bind '"\e[Z":menu-complete-backward'
      bind 'set show-all-if-ambiguous on'

      # add ~/.local/bin to PATH
      export PATH=$HOME/.local/bin:$PATH

      # enable gnome keyring to work with ssh password (if exists)
      export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh

      # start ssh agent and add key to agent
      eval "$(ssh-agent -s)" > /dev/null
      ssh-add -q ~/.ssh/ssh_id_ed25519_jordan_bravo
    '';
    # profileExtra = ''
    # '';
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
}
