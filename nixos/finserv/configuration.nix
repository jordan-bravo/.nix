# finserv/configuration.nix

{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/server-conf.nix
    # inputs.sops-nix.nixosModules.sops
  ];

  networking.hostName = "finserv";

  ### nix-bitcoin section

  # Automatically generate all secrets required by services.
  # The secrets are stored in /etc/nix-bitcoin-secrets
  nix-bitcoin.generateSecrets = true;

  # Enable some services.
  # See ../configuration.nix for all available features.
  services = {
    bitcoind = {
      enable = true;
      extraConfig = ''
        onlynet=onion
      '';
      listen = true;
      tor = {
        proxy = lib.mkDefault true;
        enforce = lib.mkDefault true;
      };
      txindex = true;
    };
    fulcrum = {
      enable = true;
      extraConfig = ''
        ssl = 0.0.0.0:50002
        cert = /var/lib/fulcrum/fulcrum-cert.pem
        key = /var/lib/fulcrum/fulcrum-key.pem
      '';
    };
    mempool = {
      enable = false;
      electrumServer = "fulcrum";
      frontend = {
        enable = true;
        # nginxConfig = {};
      };
    };
    tor = {
      enable = true;
      client.enable = true;
    };
  };
  # services.clightning.enable = true;

  # When using nix-bitcoin as part of a larger NixOS configuration, set the following to enable
  # interactive access to nix-bitcoin features (like bitcoin-cli) for your system's main user
  nix-bitcoin = {
    onionServices = {
      bitcoind.enable = lib.mkDefault true;
    };
    operator = {
      enable = true;
      name = "main";
    };
  };

  # If you use a custom nixpkgs version for evaluating your system
  # (instead of `nix-bitcoin.inputs.nixpkgs` like in this example),
  # consider setting `useVersionLockedPkgs = true` to use the exact pkgs
  # versions for nix-bitcoin services that are tested by nix-bitcoin.
  # The downsides are increased evaluation times and increased system
  # closure size.
  #
  nix-bitcoin.useVersionLockedPkgs = true;
}

