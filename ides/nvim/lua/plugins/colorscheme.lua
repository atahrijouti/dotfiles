return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "storm",
      light_style = "day",
    },
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
