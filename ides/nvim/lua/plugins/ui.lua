return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▏" },
        delete = { text = "󰐊" },
        topdelete = { text = "󰐊" },
        changedelete = { text = "╏" },
        untracked = { text = "┆" },
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  -- {
  --   "rcarriga/nvim-notify",
  --   config = function()
  --     require("notify").setup({})
  --   end,
  -- },
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
        bind_to_cwd = true,
        use_libuv_file_watcher = true,
      },
    },
  },
  {
    "MunifTanjim/nui.nvim",
  },
  {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({})
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
      },
    },
    config = function(_, opts)
      require("lspkind").init(opts)
    end,
  },
}
