# shared/servers.nix
{ config, osConfig, pkgs, ... }:
{
  imports = [
    ../shared/kitty.nix
  ];
  packages = with pkgs; [
    pkg-config # Required for borg mount
  ];
  programs.zsh = {
    initExtra = ''
      # Fix bug on NixOS with up arrow (nixos.wiki/wiki/Zsh)
      bindkey "''${key[Up]}" up-line-or-search
      # Add ssh key
      ssh-add ~/.ssh/ssh_id_ed25519_main@${osConfig.networking.hostName} 1> /dev/null 2>&1
    '';
  };
}
