return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    event = "VeryLazy",
    ft = { "org", "orgagenda" },
    config = function()
      -- Load treesitter grammar for org
      require("orgmode").setup_ts_grammar()

      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/playground/notes/**/*",
        org_default_notes_file = "~/playground/notes/refile.org",
      })
    end,
  },
}
