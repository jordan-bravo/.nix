# ~/.nix/tux/configuration.nix

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
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
  
  services.ivpn.enable = true;

  # Remap keys
  services.xremap = {
    enable = true;
    withGnome = true;
    serviceMode = "user";
    userName = "jordan";
    # yamlConfig = ''
    #   keymap:
    #     - name: main remaps:
    #         remap: 
    # '';
    config = {
      modmap = [
        {
          name = "Global";
          remap = { "Context_Menu" = "RightMeta"; };
        }
      ];
    };
  };
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "jordan" ];
  users.groups.input.members = [ "jordan" ];

  networking.hostName = "tux";

  programs.hyprland.enable = true;
}
