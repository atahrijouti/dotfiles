local telescope = require("telescope.builtin")

local module = {}

module.telescope_find_all_files = function()
  telescope.find_files({ hidden = true, no_ignore = true })
end

module.telescope_find_themes = function()
  telescope.colorscheme({ enable_preview = true })
end

module.telescope_find_words_everywhere = function()
  telescope.live_grep({
    additional_args = function(args)
      return vim.list_extend(args, { "--hidden", "--no-ignore" })
    end,
  })
end

return module
