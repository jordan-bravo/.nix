-- user/plugins/null-ls.lua

return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- JavaScript, TypeScript
        -- null_ls.builtins.formatting.prettier,

        -- Lua
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.completion.luasnip,
        -- null_ls.builtins.diagnostics.luacheck,

        -- Nix
        null_ls.builtins.formatting.nixpkgs_fmt,

        -- Python
        null_ls.builtins.formatting.black, -- .with({
        --   extra_args = { "--line-length=120" },
        -- }),
        null_ls.builtins.diagnostics.ruff,

        -- Refactoring for Go, Javascript, Lua, Python, TypeScript
        -- null_ls.builtins.code_actions.refactoring,
      },
    })
  end,
}
