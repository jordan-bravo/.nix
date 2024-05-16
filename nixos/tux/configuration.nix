# ~/.nix/tux/configuration.nix

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # This is commented out because it's a last resort.  First, determine
  # if auto ssh-add command wasn't working because the @ symbol needed to
  # be escaped or the string needed to be quoted.
  # programs.zsh = {
  #   initExtra = ''
  #     # Fix bug on NixOS with up arrow (nixos.wiki/wiki/Zsh)
  #     bindkey "''${key[Up]}" up-line-or-search
  #   '';
  #   profileExtra = ''
  #     # Add ssh key
  #     ssh-add "~/.ssh/ssh_id_ed25519_jordan@bravo"
  #   '';
  # };

  networking.hostName = "tux";

  programs.hyprland.enable = true;
}
