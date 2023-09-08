-- user/plugins/lspconfig.lua

-- NOTE: This is where your plugins related to LSP can be installed.
--  The configuration is done below. Search for lspconfig to find it below.
return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    -- { "williamboman/mason.nvim", },
    -- "williamboman/mason-lspconfig.nvim",
    -- "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim",       tag = "legacy", opts = {} },
    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
    "nvim-lua/plenary.nvim",
    -- "jose-elias-alvarez/null-ls.nvim",

  },
  config = function()
    -- [[ Configure LSP ]]
    -- require("mason").setup({
    --   -- PATH = "prepend",
    -- })
    -- require("mason-tool-installer").setup({
    --   ensure_installed = {
    --     -- JavaScript / TypeScript
    --     "prettier",                  -- fomatter
    --     "prettierd",
    --     "eslint_d",
    --     "eslint-lsp",                -- eslint
    --     "typescript-language-server", -- tsserver
    --     -- Lua
    --     "lua-language-server",       -- lua_ls
    --     -- "stylua",                    -- lua formatter
    --     -- Nix
    --     "nil",                       -- nil_ls
    --
    --     -- Python
    --     "black",                     -- formatter
    --     "pyright",                   -- type checker
    --     "ruff",                      -- linter
    --     "ruff-lsp",                  -- ruff_lsp
    --     -- Rust
    --     -- "rust-analyzer",             -- rust_analyzer
    --   },
    --   -- if set to true this will check each tool for updates. If updates
    --   -- are available the tool will be updated. This setting does not
    --   -- affect :MasonToolsUpdate or :MasonToolsInstall.
    --   -- Default: false
    --   auto_update = false,
    --
    --   -- automatically install / update on startup. If set to false nothing
    --   -- will happen on startup. You can use :MasonToolsInstall or
    --   -- :MasonToolsUpdate to install tools and check for updates.
    --   -- Default: true
    --   run_on_start = true,
    --
    --   -- If run_on_start = true, Delay (in ms) before installation starts. Default: 0
    --   -- start_delay = 3000,
    --
    --   -- Only attempt to install if 'debounce_hours' number of hours has
    --   -- elapsed since the last time Neovim was started. This stores a
    --   -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
    --   -- This is only relevant when you are using 'run_on_start'. It has no
    --   -- effect when running manually via ':MasonToolsInstall' etc....
    --   -- Default: nil
    --   -- debounce_hours = 5, -- at least 5 hours between attempts to install/update
    -- })
    local lspconfig = require("lspconfig")

    local servers = {
      -- Lua
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false }, -- make a note here of what this does
          telemetry = { enable = false },
          diagnostics = {
            -- Get the language server to recognize the "vim" global variabe
            globals = { "vim" },
          },
        },
      },
    }

    -- Setup neovim lua configuration
    require("neodev").setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- on_attach function
    local on_attach = require("user.keymaps").on_attach

    -- -- Ensure the servers above are installed
    -- local mason_lspconfig = require("mason-lspconfig")
    --
    -- mason_lspconfig.setup({
    --   -- ensure_installed = vim.tbl_keys(servers),
    --   ensure_installed = {},
    --   automatic_installation = false,
    -- })
    --
    -- mason_lspconfig.setup_handlers({
    --   function(server_name)
    --     require("lspconfig")[server_name].setup({
    --       capabilities = capabilities,
    --       on_attach = require("user.keymaps").on_attach,
    --       settings = servers[server_name],
    --     })
    --   end,
    -- })

    lspconfig.pyright.setup({})
    lspconfig.tsserver.setup({})
    lspconfig.rust_analyzer.setup({
      -- Server-specific settings. See `:help lspconfig-setup`
      cmd = { "rustup", "run", "stable", "rust-analyzer" },
      settings = {
        ['rust-analyzer'] = {
          check = {
            overrideCommand = "cargo clippy"
          }
        },
      },
    })

    -- local null_ls = require("null-ls")
    -- null_ls.setup({
    --   sources = {
    --     -- JavaScript, TypeScript
    --     -- null_ls.builtins.formatting.prettier,
    --
    --     -- Lua
    --     null_ls.builtins.formatting.stylua,
    --     -- null_ls.builtins.completion.luasnip,
    --     -- null_ls.builtins.diagnostics.luacheck,
    --
    --     -- Nix
    --     null_ls.builtins.formatting.nixpkgs_fmt,
    --
    --     -- Python
    --     null_ls.builtins.formatting.black, -- .with({
    --     --   extra_args = { "--line-length=120" },
    --     -- }),
    --     null_ls.builtins.diagnostics.ruff,
    --
    --     -- Refactoring for Go, Javascript, Lua, Python, TypeScript
    --     null_ls.builtins.code_actions.refactoring,
    --
    --     -- Rust
    --     null_ls.builtins.formatting.rustfmt,
    --   },
    -- })
  end
}
