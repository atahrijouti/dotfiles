return {
  -- { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
  { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    -- event = "BufReadPre",
    config = function()
      require("mason").setup({
        max_concurrent_installers = 4,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local lspconfig = require("lspconfig")
      local masonLspconfig = require("mason-lspconfig")

      local servers = {
        cssls = {},
        eslint = {},
        jsonls = {},
        tsserver = {},
        lua_ls = {
          Lua = {
            format = {
              enable = false,
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      masonLspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              -- capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name],
            })
          end,
        },
      })
    end,
  },
}
