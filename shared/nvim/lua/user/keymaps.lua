-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-h>", "<C-w>h")

-- Toggle File Explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Copy to end of line
vim.keymap.set("n", "Y", "y$")

-- Toggle diagnostic virtual text
vim.keymap.set("n", "<leader>v", "<Plug>(toggle-lsp-diag-vtext)", { silent = true, desc = "Toggle Virtual Text" })

-- LSP related actions:
-- Format
vim.keymap.set("n", "<leader>lf", ":lua vim.lsp.buf.format()<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>z", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Close current buffer
vim.keymap.set("n", "<leader>k", ":bd<CR>")
