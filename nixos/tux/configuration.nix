# ~/.nix/tux/configuration.nix

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.xremap-flake.nixosModules.default
    ];

  nix.settings.trusted-users = [ "root" "jordan" ];

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

  services.ivpn.enable = false;

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

  # services.ollama = {
  #   enable = true;
  # };
  #
  # services.nextjs-ollama-llm-ui = {
  #   enable = true;
  #   ollamaUrl = "http://127.0.0.1:11434";
  # };

  networking.hostName = "tux";
  networking.enableIPv6 = false;

  programs.hyprland.enable = true;

  # The following is to get Alta Legacy working on NixOS
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      # zlib # numpy
      # libgcc # sqlalchemy
      # zlib
      # that's where the shared libs go, you can find which one you need using 
      # nix-locate --top-level libstdc++.so.6  (replace this with your lib)
    ];
  };

  # Secure Boot using lanzaboote

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };


}
