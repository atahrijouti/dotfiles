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
    opts = {
      diagnostics = {
        virtual_text = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focused = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
      servers = {
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
            telemetry = { enable = false },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            runtime = {
              version = "LuaJIT",
              -- path = runtime_path,
            },
          },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local masonLspconfig = require("mason-lspconfig")

      vim.diagnostic.config(opts.diagnostics)

      masonLspconfig.setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              -- capabilities = capabilities,
              diagnostics = opts.diagnostics,
              on_attach = require("config.utils.lsp").on_attach,
              settings = opts.servers[server_name],
            })
          end,
        },
      })
    end,
  },
}
