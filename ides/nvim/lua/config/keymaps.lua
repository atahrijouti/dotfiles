local whichKey = require("which-key")
local telescope = require("telescope.builtin")
local lazy = require("lazy")
local ku = require("config.utils.keymaps")

local sections = {
  -- f = { desc = "󰍉 Find" },
  -- g = { desc = " Git" },
  -- p = { desc = "󰏖 Packages" },
  -- l = { desc = " LSP" },
  -- u = { desc = " UI" },
  -- b = { desc = "󰓩 Buffers" },
  -- d = { desc = " Debugger" },
  -- o = { desc = "󱂬 Workspace" },
  -- t = { desc = " Terminal" },
}

whichKey.register(sections, { prefix = "<leader>" })

-- stylua: ignore start
-- Top Level
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set("n", "<leader>t", "<cmd>terminal<cr>", { desc = "Terminal" })

vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })

vim.keymap.set("n", "<leader>1", "<cmd>Neotree toggle<cr>", { desc = "Project Files" })

-- Improved Terminal Navigation
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })


-- Plugin Manager
vim.keymap.set("n", "<leader>pi", lazy.install, { desc = "Plugins Install" })
vim.keymap.set("n", "<leader>ps", lazy.home, { desc = "Plugins Status" })
vim.keymap.set("n", "<leader>pS", lazy.sync, { desc = "Plugins Sync" })
vim.keymap.set("n", "<leader>pu", lazy.check, { desc = "Plugins Check Updates" })
vim.keymap.set("n", "<leader>pU", lazy.update, { desc = "Plugins Update" })
vim.keymap.set("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason Installer" })
vim.keymap.set("n", "<leader>pM", "<cmd>MasonUpdateAll<cr>", { desc = "Mason Update" })

-- Find
vim.keymap.set("n", "<leader>'", telescope.resume, { desc = "Resume previous search" })
vim.keymap.set("n", "<leader>f", telescope.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>F", ku.telescope_find_all_files, { desc = "Find all files" })
vim.keymap.set("n", "<leader>/", telescope.live_grep, { desc = "Find words" })
vim.keymap.set("n", "<leader>x/", ku.telescope_find_words_everywhere, { desc = "Find words in all files" })
vim.keymap.set("n", "<leader>xc", telescope.grep_string, { desc = "Find for word under cursor" })

vim.keymap.set("n", "<leader>b", telescope.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>?", telescope.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>xo", telescope.oldfiles, { desc = "Find history" })
vim.keymap.set("n", "<leader>xr", telescope.registers, { desc = "Find registers" })
vim.keymap.set("n", "<leader>xt", ku.telescope_find_themes, { desc = "Find themes" })

vim.keymap.set("n", "<leader>xh", telescope.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<leader>xk", telescope.keymaps, { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>xm", telescope.man_pages, { desc = "Find man pages" })

-- Git
vim.keymap.set("n", "<leader>xgb", telescope.git_branches, { desc = "Git branches" })
vim.keymap.set("n", "<leader>xgc", telescope.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>xgs", telescope.git_status, { desc = "Git status" })

-- LSP
vim.keymap.set("n", "<leader>d", function() telescope.diagnostics() end, { desc = "Search diagnostics" })

-- Workspaces
vim.keymap.set("n", "<leader>xwo", "<cmd>Telescope workspaces<cr>", { desc = "Workspaces Open" })
vim.keymap.set("n", "<leader>xwa", "<cmd>WorkspacesAdd<cr>", { desc = "Workspaces Add" })
vim.keymap.set("n", "<leader>xwr", "<cmd>WorkspacesRemove<cr>", { desc = "Workspaces Remove" })

-- stylua: ignore end
