# Shared shell aliases, imported by:
#   - modules/nixos/nixos-all.nix (environment.shellAliases — system-wide, incl. root)
#   - modules/home-manager/zsh.nix (programs.zsh.shellAliases)
{
  l = "ls -lAhF";
  lal = "ls -AhF";
  d = "docker";
  dc = "docker compose";
  gad = "git add";
  gcm = "git commit";
  gdi = "git diff";
  gfe = "git fetch";
  gme = "git merge";
  gpu = "git push";
  grb = "git rebase";
  grs = "git restore";
  gsw = "git switch";
  gsh = "git stash";
  gsu = "git status";
  hms = "home-manager switch --flake ~/.nix#$(uname -n)";
  mise-activate = "eval \"$(~/.nix-profile/bin/mise activate zsh)\"";
  nrb = "sudo nixos-rebuild boot --flake ~/.nix";
  nrs = "sudo nixos-rebuild switch --flake ~/.nix";
  sauce = "source $HOME/.config/zsh/.zshrc";
  sshk = "kitty +kitten ssh";
  td = "sudo tailscale down";
  te = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true --accept-dns=true --operator=$USER";
  tu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false --accept-dns=true --operator=$USER";
  ts = "tailscale status";
  v = "nvim";

  # Connect to machines on tailnet
  finserv = "ssh main@$(tailscale status | grep finserv | awk '{print $1}')";
  medserv = "ssh main@$(tailscale status | grep medserv | awk '{print $1}')";
  punk-ubuntu = "ssh main@$(tailscale status | grep punk-ubuntu | awk '{print $1}')";
  sovserv = "ssh main@$(tailscale status | grep sovserv | awk '{print $1}')";
}
