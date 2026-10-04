return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.nord_disable_background = true
      vim.g.nord_borders = true
      vim.g.nord_italic = false
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "nord" } },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "nord" } } },

  -- Only install the theme this configuration uses.
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
}
