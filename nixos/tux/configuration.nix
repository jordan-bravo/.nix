# ~/.nix/tux/configuration.nix

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
    ];

  # Remap keys
  services.xremap = {
    enable = true;
    withGnome = true;
    serviceMode = "system";
    userName = "jordan";
    config = {
      modmap = [
        {
          name = "Global";
          remap = { "Context_Menu" = "RightMeta"; };
        }
      ];
    };
    debug = true;
    watch = true;
  };
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "jordan" ];
  users.groups.input.members = [ "jordan" ];

  services.ivpn.enable = true;

  services.postgresql = {
    enable = false;
    package = pkgs.postgresql_14;
    ensureDatabases = [ "thefacebood-dev" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  services.redis.servers."alta" = {
    enable = false;
    port = 6379;
  };

  networking.hostName = "tux";
  # networking.enableIPv6 = false;

  programs.hyprland.enable = true;

  # The following is to get Alta Legacy working on NixOS
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # zlib # numpy
    stdenv.cc.cc.lib
    libgcc # sqlalchemy
    # that's where the shared libs go, you can find which one you need using 
    # nix-locate --top-level libstdc++.so.6  (replace this with your lib)
    # ^ this requires `nix-index` pkg
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


}
