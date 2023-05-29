return {
  "natecraddock/workspaces.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    require("workspaces").setup({
      hooks = {
        open = { "Telescope find_files" },
      },
    }),
  },
  config = function()
    require("telescope").load_extension("workspaces")
  end,
}
