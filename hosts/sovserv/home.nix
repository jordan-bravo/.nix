# sovserv/home.nix

{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared/home.nix
    ../shared/servers.nix
  ];
}
