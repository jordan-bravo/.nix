-- user/plugins/lualine.lua

return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = "auto",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        {
          "filename",
          path = 3,
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    -- tabline = {
    --   lualine_a = { "buffers" },
    --   lualine_b = { "branch" },
    --   lualine_c = { "filename" },
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = { "tabs" },
    -- },
  },
}
