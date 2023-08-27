-- user/plugins/colorscheme.lua

return {
  -- Colorscheme / Theme inspired by VSCode
  {
    "Mofiqul/vscode.nvim",
    lazy = false,  -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd.colorscheme("vscode")
    end,
  },
}
