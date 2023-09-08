-- user/plugins/lsp-format.lua

return {
  "lukas-reineke/lsp-format.nvim",
  config = function()
    require("lsp-format").setup({}) 

    local on_attach = function(client, bufnr)
        require("lsp-format").on_attach(client, bufnr)

        -- ... custom code ...
    end
    require("lspconfig").rust_analyzer.setup({ on_attach = on_attach })
  end
}
