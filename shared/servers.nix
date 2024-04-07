# shared/servers.nix
{
  programs.zsh = {
    profileExtra = ''
      # Add ssh key
      ssh-add ~/.ssh/ssh_id_ed25519_main@${hostname}.key
    '';
  };
}
