# ~/.nix/shared/neovim.nix

{ config, inputs, pkgs, ... }:
{
  # vimjoyer approach
  nixpkgs = {
    overlays = [
      (final: prev: {
        vimPlugins = prev.vimPlugins // {
          colorscheme-vscode = prev.vimUtils.buildVimPlugin {
            name = "vscode";
            src = inputs.colorscheme-vscode;
          };
        };
      })
    ];
  };

  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = false;
    defaultEditor = true;
    # extraLuaConfig = builtins.readFile ./nvim/init.lua;
    extraPackages = with pkgs; [
      luajitPackages.lua-lsp
      luajitPackages.luacheck
      wl-clipboard
    ];
    # extraPython3Packages = with pyPkgs; [
    #   debugpy
    # ];
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      cmp_luasnip
      cmp-fuzzy-buffer
      cmp-nvim-lsp
      cmp-path
      {
        plugin = colorscheme-vscode;
        type = "lua";
        config = ''
          vim.cmd.colorscheme("vscode")
        '';
      }
      comment-nvim
      conform-nvim
      dressing-nvim
      friendly-snippets
      gitsigns-nvim
      indent-blankline-nvim
      lspkind-nvim
      lualine-nvim
      luasnip
      neodev-nvim
      nvcode-color-schemes-vim
      nvim-autopairs
      nvim-cmp
      nvim-dap
      nvim-dap-python
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-lint
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-web-devicons
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      vim-fugitive
      # vim-nix # maybe?
      vim-numbertoggle
      vim-rhubarb
      vim-sleuth
      which-key-nvim
      
      # parsers for treesitter
      {
	plugin = (nvim-treesitter.withPlugins (p: [
	  p.tree-sitter-bash
	  p.tree-sitter-css
	  p.tree-sitter-go
	  p.tree-sitter-html
	  p.tree-sitter-javascript
	  p.tree-sitter-json
	  p.tree-sitter-lua
	  p.tree-sitter-nix
	  p.tree-sitter-python
	  p.tree-sitter-scss
	  p.tree-sitter-typescript
	  p.tree-sitter-vim
	]));
	config = toLuaFile ./nvim/treesitter.lua;
      }
      # The following nvim plugins aren't in nixpkgs:
      # fladson/vim-kitty
      # Mofiqul/vscode.nvim
      # WhoIsSethDaniel/toggle-lsp-diagnostic.nvim

    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };
  # xdg.configFile.nvim = {
  #   recursive = true;
  #   source = ./nvim;
  # };

  # programs.neovim.extraLuaConfig = ''
  #   vim.cmd.colorscheme("nvcode")
  # '';
  imports = [ ../shared/nvim/options.nix ];
}
