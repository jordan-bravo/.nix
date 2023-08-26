# ~/.nix/mbp/configuration.nix

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  users.users.jordan.home = "/Users/jordan";

  environment.systemPackages = with pkgs; [
    # firefox
  ];

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;

  system.stateVersion = 4;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}
