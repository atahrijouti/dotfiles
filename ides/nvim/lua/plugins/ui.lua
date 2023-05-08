return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    tag = "release",
    ft = "gitcommit",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "rcarriga/nvim-notify",
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "User",
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
    },
    -- opts = { user_default_options = { names = false } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    opts = {
      window = {
        position = "left",
        width = 30,
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        follow_current_file = true,
      },
    },
  },
  {
    "MunifTanjim/nui.nvim",
  },
}
