# shared/servers.nix
{ config, osConfig, ... }:
{
  programs.zsh = {
    initExtra = ''
      # Fix bug on NixOS with up arrow (nixos.wiki/wiki/Zsh)
      bindkey "''${key[Up]}" up-line-or-search
    '';
    profileExtra = ''
      # Add ssh key
      ssh-add ~/.ssh/ssh_id_ed25519_main@${osConfig.networking.hostName}
    '';
  };
}
