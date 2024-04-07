# ~/server-conf/sovserv/home.nix

{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared/home.nix
    ../shared/servers.nix
  ];

  # programs = {
  #   kitty = {
  #     enable = true;
  #     font = {
  #       name = "FiraCode Nerd Font Mono";
  #     };
  #   };
  # };
}
