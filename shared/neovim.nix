# ~/.nix/shared/neovim.nix

{ inputs, pkgs, ... }:
let
  move_selection_next = [ ];
  move_selection_previous = [ ];
in
{

  ###### NixNeovim

  # programs.nixneovim = {
  #   enable = false;
  #   augroups = {
  #     highlightOnYank = {
  #       autocmds = [
  #         {
  #           event = "TextYankPost";
  #           pattern = "*";
  #           luaCallback = ''
  #             vim.highlight.on_yank {
  #               higroup = (
  #                 vim.fn['hlexists'] 'HighlightedyankRegion' > 0 and 'HighlightedyankRegion' or 'IncSearch'
  #               ),
  #               timeout = 200,
  #             }
  #           '';
  #         }
  #       ];
  #     };
  #   };
  #   colorschemes = {
  #     vscode = {
  #       enable = true;
  #     };
  #   };
  #   defaultEditor = true;
  #   # extraConfigLua is generated at bottom of init.lua,
  #   # whereas extraLuaConfig is generated at top
  #   extraConfigLua = ''
  #     -- TODO: Make telescope search all files, including hidden files and those listed in .gitignore.  Default is to exclude those.
  #     -- local find_files = function()
  #     --   require("telescope.builtin").find_files({
  #     --     find_command = { "rg", "--files", "--hidden", },
  #     --   })
  #     -- end
  #
  #     -- Enable telescope fzf native, if installed
  #     pcall(require("telescope").load_extension, "fzf")
  #
  #     -- See `:help telescope.builtin`
  #     vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
  #     vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
  #     vim.keymap.set("n", "<leader>/", function()
  #       -- You can pass additional configuration to telescope to change theme, layout, etc.
  #       require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
  #         winblend = 10,
  #         previewer = false,
  #       }))
  #     end, { desc = "[/] Fuzzily search in current buffer" })
  #
  #     vim.keymap.set("n", "<leader>if", require("telescope.builtin").git_files, { desc = "Search G[i]t [F]iles" })
  #     vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
  #     vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files, { desc = "Find [F]iles" })
  #     vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
  #     vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
  #     vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
  #     vim.keymap.set("n", "<leader>t", require("telescope.builtin").live_grep, { desc = "Find [T]ext" })
  #     vim.keymap.set("n", "<leader>g", require("telescope.builtin").live_grep, { desc = "Find by [G]rep" })
  #     vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
  #   '';
  #   extraPlugins = [
  #     pkgs.vimExtraPlugins.nvim-web-devicons
  #     pkgs.vimExtraPlugins.telescope-fzf-native-nvim
  #   ];
  #   mappings = {
  #     normal = {
  #       # Example with vimpscript
  #       "<leader>w" = {
  #         action = "'<cmd>w<cr>'"; # vimscript between ' '
  #         silent = true;
  #       };
  #       # Example with Lua
  #       "<leader>h" = "function() print(\"hi\") end"; # Doesn't require single quotes: ' '
  #     };
  #   };
  #   plugins = {
  #     barbar = {
  #       enable = true;
  #     };
  #     bufdelete = {
  #       enable = true;
  #     };
  #     comment = {
  #       enable = true;
  #     };
  #     copilot = {
  #       enable = false;
  #     };
  #     dashboard = {
  #       enable = false;
  #     };
  #     diffview = {
  #       enable = true;
  #     };
  #     endwise = {
  #       enable = true;
  #     };
  #     fugitive = {
  #       enable = true;
  #     };
  #     ghosttext = {
  #       enable = false;
  #     };
  #     git-messenger = {
  #       enable = true;
  #     };
  #     gitsigns = {
  #       enable = true;
  #     };
  #     hbac = {
  #       # heuristic buffer auto-close
  #       enable = false;
  #     };
  #     headlines = {
  #       enable = true;
  #     };
  #     incline = {
  #       enable = false;
  #     };
  #     indent-blankline = {
  #       enable = true;
  #     };
  #     intellitab.enable = true;
  #     lsp-lines = {
  #       enable = false;
  #     };
  #     lsp-progress = {
  #       enable = true;
  #     };
  #     lsp-signature = {
  #       enable = true;
  #     };
  #     lspconfig = {
  #       enable = true;
  #       onAttach = ''
  #         opts.buffer = bufnr
  #
  #         opts.desc = "Show LSP references"
  #         vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
  #
  #         opts.desc = "Go to declaration"
  #         vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
  #
  #         opts.desc = "Show LSP definitions"
  #         vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
  #
  #         opts.desc = "Show LSP implementations"
  #         vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
  #
  #         opts.desc = "Show LSP type definitions"
  #         vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
  #
  #         opts.desc = "See available code actions"
  #         vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
  #
  #         opts.desc = "Smart rename"
  #         vim.keymap.set("n", "<leader>rs", vim.lsp.buf.rename, opts) -- smart rename
  #
  #         opts.desc = "Show buffer diagnostics"
  #         vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
  #
  #         opts.desc = "Show line diagnostics"
  #         vim.keymap.set("n", "<leader>z", vim.diagnostic.open_float, opts) -- show diagnostics for line
  #
  #         opts.desc = "Go to previous diagnostic"
  #         vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
  #
  #         opts.desc = "Go to next diagnostic"
  #         vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
  #
  #         opts.desc = "Show documentation for what is under cursor"
  #         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
  #
  #         opts.desc = "Restart LSP"
  #         vim.keymap.set("n", "<leader>rl", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
  #
  #         opts.desc = "[D]ocument [S]ymbols"
  #         vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols,
  #         	{ buffer = bufnr, desc = opts.desc })
  #
  #         opts.desc = "[W]orkspace [S]ymbols"
  #         vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols,
  #         	{ buffer = bufnr, desc = opts.desc })
  #
  #         -- See `:help K` for why this keymap
  #         opts.desc = "Hover Documentation"
  #         vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = opts.desc })
  #
  #         opts.desc = "Signature Documentation"
  #         vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = opts.desc })
  #
  #         -- Lesser used LSP functionality
  #         opts.desc = "[G]oto [D]eclaration"
  #         vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = opts.desc })
  #
  #         opts.desc = "[W]orkspace [A]dd Folder"
  #         vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = opts.desc })
  #
  #         opts.desc = "[W]orkspace [R]emove Folder"
  #         vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = opts.desc })
  #
  #         -- local list_workspace_folders = function()
  #         --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  #         -- end
  #         -- opts.desc = "[W]orkspace [L]ist Folders"
  #         -- vim.keymap.set("n", "<leader>wl", list_workspace_folders(), { buffer = bufnr, desc = opts.desc })
  #         				'';
  #       servers = {
  #         bashls.enable = true;
  #         lua-language-server = {
  #           enable = false;
  #           extraConfig = ''
  #               on_init = function(client)
  #             	local path = client.workspace_folders[1].name
  #             	if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
  #             		client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
  #             			Lua = {
  #             				runtime = {
  #             					-- Tell the language server which version of Lua you're using
  #             					-- (most likely LuaJIT in the case of Neovim)
  #             					version = 'LuaJIT'
  #             				},
  #             				-- Make the server aware of Neovim runtime files
  #             				workspace = {
  #             					checkThirdParty = false,
  #             					library = {
  #             						vim.env.VIMRUNTIME
  #             						-- "''${3rd}/luv/library"
  #             						-- "''${3rd}/busted/library",
  #             					}
  #             					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
  #             					-- library = vim.api.nvim_get_runtime_file("", true)
  #             				}
  #             			}
  #             		})
  #
  #             		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  #             	end
  #             	return true
  #               end
  #           '';
  #         };
  #         nil.enable = true;
  #         pyright.enable = true;
  #         ruff-lsp.enable = true;
  #         rust-analyzer.enable = true;
  #       };
  #     };
  #     lspkind.enable = true;
  #     lualine = {
  #       enable = true;
  #       theme = "vscode";
  #     };
  #     neogit.enable = false;
  #     nest.enable = false;
  #     nix.enable = false; # find out what this does
  #     notify.enable = true;
  #     nvim-autopairs.enable = true;
  #     nvim-cmp = {
  #       enable = true;
  #       mapping = {
  #         "<CR>" = "cmp.mapping.confirm({ select = true })";
  #         "<Tab>" = {
  #           modes = [ "i" "s" ];
  #           action = ''
  #             function(fallback)
  #               if cmp.visible() then
  #                 cmp.select_next_item()
  #               elseif luasnip.expandable() then
  #                 luasnip.expand()
  #               elseif luasnip.expand_or_jumpable() then
  #                 luasnip.expand_or_jump()
  #               elseif check_backspace() then
  #                 fallback()
  #               else
  #                 fallback()
  #               end
  #             end
  #           '';
  #         };
  #       };
  #
  #       snippet.luasnip.enable = true;
  #       sources = {
  #         # buffer.enable = true;
  #         luasnip.enable = true;
  #         nvim_lsp.enable = true;
  #       };
  #     };
  #     nvim-dap = {
  #       enable = true;
  #       # adapters = {};
  #     };
  #     nvim-dap-ui = {
  #       enable = true;
  #     };
  #     nvim-jqx.enable = false;
  #     nvim-lightbulb.enable = false;
  #     nvim-tree = {
  #       enable = true;
  #       # autoClose = true;
  #       diagnostics = {
  #         enable = true;
  #         # icons = {
  #         #   error = "";
  #         #   hint = "";
  #         #   info = "";
  #         #   warning = "";
  #         # };
  #       };
  #       disableNetrw = true;
  #       filters = {
  #         dotfiles = false;
  #       };
  #       git = {
  #         enable = true;
  #         ignore = false;
  #       };
  #     };
  #     origami.enable = false;
  #     plenary.enable = true;
  #     project-nvim = {
  #       enable = false;
  #     };
  #     scrollbar.enable = true;
  #     surround.enable = true;
  #     telescope = {
  #       enable = true;
  #       # need to figure out how to configure telescope within nixneovim
  #       #    extraConfig = {
  #       # mappings = {
  #       # 	i = {
  #       # 		"<C-u>" = false;
  #       # 		"<C-d>" = false;
  #       # 		"<C-k>" = telescope.actions.move_selection_previous;
  #       # 		"<C-j>" = telescope.actions.move_selection_next;
  #       # 		# "<C-q>" = "actions.send_selected_to_qflist + actions.open_qflist";
  #       # 	};
  #       # };
  #       # # pickers = {
  #       # # 	find_files = {
  #       # # 		hidden = true;
  #       # # 	};
  #       # # };
  #       # };
  #       #    extraLua.pre = ''
  #       #    	local actions = require("telescope.actions")
  #       # local move_selection_previous = actions.move_selection_previous
  #       #    '';
  #     };
  #     todo-comments.enable = true;
  #     treesitter = {
  #       enable = true;
  #       folding = true;
  #       indent = true;
  #       installAllGrammars = true;
  #     };
  #     treesitter-context.enable = false;
  #     ts-context-commentstring.enable = true;
  #     which-key.enable = false;
  #   };
  #   usePluginDefaults = true;
  #   viAlias = true;
  #   vimAlias = true;
  # };

  home.file = {
    ".config/nvim/after/ftplugin/go.lua" = {
      enable = false;
      text = ''
        vim.opt.tabstop = 4
      '';
    };
    ".config/nvim/after/ftplugin/nix.lua" = {
      enable = false;
      text = ''
        vim.opt.tabstop = 2
      '';
    };
    ".config/nvim/.stylua.toml" = {
      enable = false;
      text = ''
        indent_type = "Spaces"
        indent_width = 2
      '';
    };
  };

  # imports = [ inputs.nixneovim.nixosModules.default ../shared/nvim/options.nix ];

}
