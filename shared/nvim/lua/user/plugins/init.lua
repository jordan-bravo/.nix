-- user/plugins/init.lua

return {
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- Syntax highlighting for kitty config
  "fladson/vim-kitty",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim",  opts = {} },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = "┊",
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },
}
