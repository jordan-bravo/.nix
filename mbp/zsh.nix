# ~/.nix/shared/zsh.nix
{ pkgs, ... }:

{
  programs.zsh = {
    localVariables = {
      PATH = "/opt/homebrew/bin:$PATH";
    };
  };
}
