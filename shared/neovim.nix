# ~/.nix/shared/neovim.nix

{ config, inputs, pkgs, ... }:
{

  ###### NixNeovim

  programs.nixneovim = {
    enable = true;
    augroups = {
      highlightOnYank = {
        autocmds = [
          {
            event = "TextYankPost";
            pattern = "*";
            luaCallback = ''
              vim.highlight.on_yank {
                higroup = (
                  vim.fn['hlexists'] 'HighlightedyankRegion' > 0 and 'HighlightedyankRegion' or 'IncSearch'
                ),
                timeout = 200,
              }
            '';
          }
        ];
      };
    };
    colorscheme = "slate";
    defaultEditor = true;
    # extraPlugins = [
    #   pkgs.vimExtraPlugins.vscode-nvim
    # ];
    mappings = {
      # normalVisualOp = {
      #   ";" = "':'"; # vimscript between ' '
      # };
      normal = {
        "<leader>w" = {
          action = "'<cmd>w<cr>'"; # vimscript between ' '
          silent = true;
        };
        "<leader>h" = "function() print(\"hi\") end"; # Lua code without ' '
      };
    };
    plugins = {
      barbar = {
        enable = true;
      };
      bufdelete = {
        enable = true;
      };
      comment = {
        enable = true;
      };
      copilot = {
        enable = false;
      };
      dashboard = {
        enable = false;
      };
      diffview = {
        enable = true;
      };
      endwise = {
        enable = true;
      };
      fugitive = {
        enable = true;
      };
      ghosttext = {
        enable = false;
      };
      git-messenger = {
        enable = true;
      };
      gitsigns = {
        enable = true;
      };
      hbac = { # heuristic buffer auto-close
        enable = false;
      };
      headlines = {
        enable = true;
      };
      incline = {
        enable = false;
      };
      indent-blankline = {
        enable = true;
      };
      intellitab.enable = true;
      lsp-lines = {
        enable = false;
      };
      lsp-progress = {
        enable = true;
      };
      lsp-signature = {
        enable = true;
      };
      lspconfig = {
        enable = true;
        servers = {
          bashls.enable = true;
          lua-language-server.enable = true;
          nil.enable = true;
          pyright.enable = true;
          ruff-lsp.enable = true;
        };
      };
      lspkind.enable = true;
      lualine = {
        enable = true;
        theme = "codedark";
      };
      neogit.enable = false;
      nest.enable = false;
      nix.enable = false; # find out what this does
      notify.enable = true;
      nvim-autopairs.enable = true;
      nvim-cmp = {
        enable = false;
      };
      nvim-dap = {
        enable = true;
        # adapters = {};
      };
      nvim-dap-ui = {
        enable = true;
      };
      nvim-jqx.enable = false;
      nvim-lightbulb.enable = false;
      nvim-tree = {
        enable = true;
        # autoClose = true;
        diagnostics = {
          enable = false;
          icons = {
            error = "";
            hint = "";
            info = "";
            warning = "";
          };
        };
        disableNetrw = true;
      };
      origami.enable = false;
      plenary.enable = true;
      project-nvim = {
        enable = false;
      };
      scrollbar.enable = true;
      surround.enable = true;
      telescope = {
        enable = true;
      };
      todo-comments.enable = true;
      treesitter = {
        enable = true;
        folding = true;
        # grammars = [
        #   pkgs.vimPlugins.nvim-treesitter-parsers.bash
        #   pkgs.vimPlugins.nvim-treesitter-parsers.javascript
        #   pkgs.vimPlugins.nvim-treesitter-parsers.jq
        #   pkgs.vimPlugins.nvim-treesitter-parsers.json
        #   pkgs.vimPlugins.nvim-treesitter-parsers.lua
        #   pkgs.vimPlugins.nvim-treesitter-parsers.markdown
        #   pkgs.vimPlugins.nvim-treesitter-parsers.python
        #   pkgs.vimPlugins.nvim-treesitter-parsers.typescript
        # ];
        indent = true;
        installAllGrammars = true;
      };
      treesitter-context.enable = false;
      ts-context-commentstring.enable = true;
      which-key.enable = false;
      # pkgs.vimExtraPlugins.vscode-nvim
      # vscode-nvim.enable = true;
    };
    usePluginDefaults = true;
    viAlias = true;
    vimAlias = true;
  };

  imports = [ inputs.nixneovim.nixosModules.default ../shared/nvim/options.nix ];









  ###### Neovim standard
  
  # nixpkgs = {
  #   overlays = [
  #     (final: prev: {
  #       vimPlugins = prev.vimPlugins // {
  #         colorscheme-vscode = prev.vimUtils.buildVimPlugin {
  #           name = "vscode";
  #           src = inputs.colorscheme-vscode;
  #         };
  #       };
  #     })
  #   ];
  # };

  # programs.neovim = 
  # let
  #   toLua = str: "lua << EOF\n${str}\nEOF\n";
  #   toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  # in
  # {
  #   enable = false;
  #   defaultEditor = true;
  #   # extraLuaConfig = builtins.readFile ./nvim/init.lua;
  #   extraPackages = with pkgs; [
  #     luajitPackages.lua-lsp
  #     luajitPackages.luacheck
  #     wl-clipboard
  #   ];
  #   # extraPython3Packages = with pyPkgs; [
  #   #   debugpy
  #   # ];
  #   plugins = with pkgs.vimPlugins; [
  #     bufferline-nvim
  #     cmp_luasnip
  #     cmp-fuzzy-buffer
  #     cmp-nvim-lsp
  #     cmp-path
  #     {
	# # plugin = pkgs.vimUtils.buildVimPlugin {
	# #   name = "vscode";
	# #   src = inputs.colorscheme-vscode;
	# # };
  #       plugin = colorscheme-vscode;
  #       type = "lua";
  #       config = ''
	#   require('vscode').setup({})
  #       '';
  #     }
  #     comment-nvim
  #     conform-nvim
  #     dressing-nvim
  #     friendly-snippets
  #     gitsigns-nvim
  #     indent-blankline-nvim
  #     lspkind-nvim
  #     lualine-nvim
  #     luasnip
  #     neodev-nvim
  #     nvcode-color-schemes-vim
  #     nvim-autopairs
  #     nvim-cmp
  #     nvim-dap
  #     nvim-dap-python
  #     nvim-dap-ui
  #     nvim-dap-virtual-text
  #     nvim-lint
  #     nvim-lspconfig
  #     nvim-tree-lua
  #     nvim-treesitter
  #     nvim-treesitter-textobjects
  #     nvim-web-devicons
  #     plenary-nvim
  #     telescope-nvim
  #     telescope-fzf-native-nvim
  #     vim-fugitive
  #     # vim-nix # maybe?
  #     vim-numbertoggle
  #     vim-rhubarb
  #     vim-sleuth
  #     which-key-nvim
      
  #     # parsers for treesitter
  #     {
	# plugin = (nvim-treesitter.withPlugins (p: [
	#   p.tree-sitter-bash
	#   p.tree-sitter-css
	#   p.tree-sitter-go
	#   p.tree-sitter-html
	#   p.tree-sitter-javascript
	#   p.tree-sitter-json
	#   p.tree-sitter-lua
	#   p.tree-sitter-nix
	#   p.tree-sitter-python
	#   p.tree-sitter-scss
	#   p.tree-sitter-typescript
	#   p.tree-sitter-vim
	# ]));
	# config = toLuaFile ./nvim/treesitter.lua;
  #     }
  #     # The following nvim plugins aren't in nixpkgs:
  #     # fladson/vim-kitty
  #     # Mofiqul/vscode.nvim
  #     # WhoIsSethDaniel/toggle-lsp-diagnostic.nvim

  #   ];
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  #   withNodeJs = true;
  #   withPython3 = true;
  # };
}
