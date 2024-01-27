# ~/.nix/shared/nvim/options.nix

{
  programs.neovim.extraLuaConfig = ''
    -- user/options.lua
    
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    -- Since leader key is space, unmap space when in normal mode
    vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

    -- Don't start with text folded
    vim.opt.foldenable = false

		-- Set default tabstop
		vim.opt.tabstop = 4

		-- Insert spaces when pressing tab
		vim.opt.expandtab = true

    -- Set shiftwidth equal to tabstop
    vim.opt.shiftwidth = 0

    -- Set softtabstop equal to tabstop
    vim.opt.softtabstop = 0

    -- vim.opt.filetype = "on" -- not sure if this is necessary

    -- Disable netrw and replace with a plugin
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    
    -- Set highlight on search
    vim.o.hlsearch = false
    
    -- Make line numbers default and relative
    vim.wo.number = true
    vim.opt.relativenumber = true
    
    -- Enable mouse mode
    vim.o.mouse = "a"
    
    -- Make titlebar show current file name/path
    vim.opt.title = true
    vim.opt.titlestring = "%F"
    
    -- Sync clipboard between OS and Neovim.
    --  Remove this option if you want your OS clipboard to remain independent.
    --  See `:help 'clipboard'`
    -- vim.o.clipboard = 'unnamedplus'
    
    -- Enable break indent
    vim.o.breakindent = true
    
    -- Don't line break in the middle words
    vim.opt.linebreak = true
    
    -- Save undo history
    vim.o.undofile = true
    
    -- Case insensitive searching UNLESS /C or capital in search
    vim.o.ignorecase = true
    vim.o.smartcase = true
    
    -- Keep signcolumn on by default
    vim.wo.signcolumn = "yes"
    
    -- Decrease update time
    vim.o.updatetime = 250
    vim.o.timeout = true
    vim.o.timeoutlen = 750
    
    -- Set completeopt to have a better completion experience
    vim.o.completeopt = "menuone,noselect"
    
    vim.o.termguicolors = true
    
    -- [[ Keymaps ]]

    -- Toggle File Explorer
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })

    -- Toggle diagnostic virtual text (plugin required)
    -- vim.keymap.set("n", "<leader>v", "<Plug>(toggle-lsp-diag-vtext)", { silent = true, desc = "Toggle Virtual Text" })
        
    -- Diagnostic keymaps
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

    -- Close current buffer
    vim.keymap.set("n", "<leader>k", ":bd<CR>", { silent = true })
    
    -- Remap for dealing with word wrap
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
      
    -- Navigate buffers
    -- vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
    vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
    -- vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
    vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { silent = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
    vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
    
    -- Buffer keymap options table
    local opts = { noremap = true, silent = true } 
  '';
}
