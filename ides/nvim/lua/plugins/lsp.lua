return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
  { "folke/neoconf.nvim", cmd = "Neoconf",                                config = true },
  { "folke/neodev.nvim",  opts = { experimental = { pathStrict = true } } },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    -- event = "BufReadPre",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
      },
    },
    config = function()
      require("mason").setup({
        max_concurrent_installers = 4,
      })
      require("mason-lspconfig").setup {
        ensure_installed = {
          "bashls",
          "cssls",
          "eslint",
          "jsonls",
          "kotlin_language_server",
          "lua_ls",
          "marksman",
          "sqlls",
          "tsserver",
        },
        automatic_installation = true,
      }
    end
  }
}
