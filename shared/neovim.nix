# ~/.nix/shared/neovim.nix

{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # extraLuaConfig = ''
    #   
    # '';
    # extraLuaConfig = builtins.readFile ./nvim/init.lua;
    extraPackages = with pkgs; [
      luajitPackages.luacheck
    ];
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };
  xdg.configFile.nvim = {
    recursive = true;
    source = ./nvim;
  };
}
