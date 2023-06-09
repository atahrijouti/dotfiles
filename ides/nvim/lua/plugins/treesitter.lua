return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  event = "User",
  cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "rust",
      "vim",
      "yaml",
    },
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > 10000
      end,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-=>",
        node_incremental = "<M-=>",
        scope_incremental = "<nop>",
        node_decremental = "<M-->",
      },
    },
    indent = { enable = true },
    autotag = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
