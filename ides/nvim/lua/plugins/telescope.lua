return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    cmd = "Telescope",
    dependencies = {
      -- "nvim-lua/plenary.nvim",
      "telescope-fzf-native.nvim",
      -- "project.nvim",
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-lua/plenary.nvim",
    cmd = {
      "PlenaryBustedFile",
      "PlenaryBustedDirectory",
    },
  },
}
