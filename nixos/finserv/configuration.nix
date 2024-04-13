# finserv/configuration.nix

{ config, inputs, pkgs, ... }:

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
  services.bitcoind = {
    enable = true;
    txindex = true;
  };
  # services.clightning.enable = true;

  # When using nix-bitcoin as part of a larger NixOS configuration, set the following to enable
  # interactive access to nix-bitcoin features (like bitcoin-cli) for your system's main user
  nix-bitcoin.operator = {
    enable = true;
    name = "main";
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

