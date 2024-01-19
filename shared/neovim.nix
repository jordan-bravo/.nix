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
    colorscheme = "habamax";
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
      hbac = {
        # heuristic buffer auto-close
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
        onAttach = ''
          opts.buffer = bufnr
          
          opts.desc = "Show LSP references"
          vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
          
          opts.desc = "Go to declaration"
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
          
          opts.desc = "Show LSP definitions"
          vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
          
          opts.desc = "Show LSP implementations"
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
          
          opts.desc = "Show LSP type definitions"
          vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
          
          opts.desc = "See available code actions"
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
          
          opts.desc = "Smart rename"
          vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename, opts) -- smart rename
          
          opts.desc = "Show buffer diagnostics"
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
          
          opts.desc = "Show line diagnostics"
          vim.keymap.set("n", "<leader>z", vim.diagnostic.open_float, opts) -- show diagnostics for line
          
          opts.desc = "Go to previous diagnostic"
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
          
          opts.desc = "Go to next diagnostic"
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
          
          opts.desc = "Show documentation for what is under cursor"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
          
          opts.desc = "Restart LSP"
          vim.keymap.set("n", "<leader>rl", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
          
          opts.desc = "[D]ocument [S]ymbols"
          vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols,
          	{ buffer = bufnr, desc = opts.desc })
          
          opts.desc = "[W]orkspace [S]ymbols"
          vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols,
          	{ buffer = bufnr, desc = opts.desc })
          
          -- See `:help K` for why this keymap
          opts.desc = "Hover Documentation"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = opts.desc })
          
          opts.desc = "Signature Documentation"
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = opts.desc })
          
          -- Lesser used LSP functionality
          opts.desc = "[G]oto [D]eclaration"
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = opts.desc })
          
          opts.desc = "[W]orkspace [A]dd Folder"
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = opts.desc })
          
          opts.desc = "[W]orkspace [R]emove Folder"
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = opts.desc })
          
          -- local list_workspace_folders = function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end
          -- opts.desc = "[W]orkspace [L]ist Folders"
          -- vim.keymap.set("n", "<leader>wl", list_workspace_folders(), { buffer = bufnr, desc = opts.desc })
          				'';
        servers = {
          bashls.enable = true;
          lua-language-server = {
            enable = false;
            extraConfig = ''
                on_init = function(client)
              	local path = client.workspace_folders[1].name
              	if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
              		client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              			Lua = {
              				runtime = {
              					-- Tell the language server which version of Lua you're using
              					-- (most likely LuaJIT in the case of Neovim)
              					version = 'LuaJIT'
              				},
              				-- Make the server aware of Neovim runtime files
              				workspace = {
              					checkThirdParty = false,
              					library = {
              						vim.env.VIMRUNTIME
              						-- "''${3rd}/luv/library"
              						-- "''${3rd}/busted/library",
              					}
              					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              					-- library = vim.api.nvim_get_runtime_file("", true)
              				}
              			}
              		})

              		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
              	end
              	return true
                end
            '';
          };
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
