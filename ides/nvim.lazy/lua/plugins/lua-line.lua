return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local function attached_clients()
      return "(" .. vim.tbl_count(vim.lsp.buf_get_clients(0)) .. ")"
    end

    local function cwd()
      return vim.fn.fnamemodify(vim.loop.cwd(), ":~")
    end

    return {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", cwd, "diagnostics" },
        lualine_c = {},
        lualine_x = {
          "filesize",
          "encoding",
          "filetype",
          { attached_clients },
        },
        lualine_y = {},
        lualine_z = {
          { "location", padding = { left = 0, right = 1 } },
        },
      },
      inactive_winbar = {
        lualine_b = { { "filename", path = 1 } },
      },
      winbar = {
        lualine_b = { { "filename", path = 1 } },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
