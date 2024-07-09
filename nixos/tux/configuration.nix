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

  services.ollama = {
    enable = true;
  };

  services.nextjs-ollama-llm-ui = {
    enable = true;
    ollamaUrl = "http://127.0.0.1:11434";
  };

  networking.hostName = "tux";
  # networking.enableIPv6 = false;

  programs.hyprland.enable = true;

  # The following is to get Alta Legacy working on NixOS
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # zlib # numpy
    # stdenv.cc.cc.lib
    libgcc # sqlalchemy
    # zlib
    # that's where the shared libs go, you can find which one you need using 
    # nix-locate --top-level libstdc++.so.6  (replace this with your lib)
    # ^ this requires `nix-index` pkg
  ];
}
