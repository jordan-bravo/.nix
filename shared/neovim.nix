# ~/.nix/shared/neovim.nix

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # extraLuaConfig = ''
    #   
    # '';
  };
}
