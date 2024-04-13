# shared/servers.nix
{ config, osConfig, ... }:
{
  programs.zsh = {
    profileExtra = ''
      # Add ssh key
      ssh-add ~/.ssh/ssh_id_ed25519_main@${osConfig.networking.hostName}
    '';
  };
}
