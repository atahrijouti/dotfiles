return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "storm",
      light_style = "day",
    },
    config = function(opts)
      vim.cmd([[colorscheme tokyonight]])
      require("tokyonight").setup(opts)
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    config = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        -- vim.cmd("colorscheme tokyonight")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        -- vim.cmd("colorscheme tokyonight")
      end,
    },
  },
}
