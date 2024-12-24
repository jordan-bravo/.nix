{
  programs.bash = {
    enableCompletion = true;
    # bashrcExtra = ''
    #   # Add ssh key, suppress output
    #   ssh-add "$HOME/.ssh/ssh_id_ed25519_jordan@bravo" 1> /dev/null 2>&1
    # '';
    historyControl = [ "erasedups" ];
    profileExtra = ''
      eval "$(ssh-agent -s)" > /dev/null
      ssh-add ~/.ssh/ssh_id_ed25519_jordan@bravo > /dev/null
    '';
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
