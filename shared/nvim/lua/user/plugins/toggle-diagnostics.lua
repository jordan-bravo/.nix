-- user/plugins/toggle_diagnostics.lua

return {
  {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require("toggle_lsp_diagnostics").init({
        virtual_text = false,
      })
    end,
  },
}
