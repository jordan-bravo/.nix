# finserv/configuration.nix

{ config, inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/server-conf.nix
    # inputs.sops-nix.nixosModules.sops
  ];


  networking.hostName = "finserv";

  # environment.systemPackages = with pkgs; [
  # ];

  services = {
    # Examples
    # postgresql = {
    #   ensureDatabases = [ "name-of-database" ];
    # };
    # postgresqlBackup = {
    #   enable = true;
    #   databases = [ "name-of-database" ];
    #   startAt = "*-*-* 03:15:00";
    # };
  };
}

