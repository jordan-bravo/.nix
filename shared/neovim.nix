# ~/.nix/shared/neovim.nix

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # extraLuaConfig = ''
    #   
    # '';
    # extraLuaConfig = builtins.readFile ./nvim/init.lua;
  };
  xdg.configFile.nvim = {
    recursive = true;
    source = ./nvim;
  };
}
