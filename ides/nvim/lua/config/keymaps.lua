local sections = {
	f = { desc = "󰍉 Find" },
	g = { desc = " Git" },
	p = { desc = "󰏖 Packages" },
	-- l = { desc = " LSP" },
	-- u = { desc = " UI" },
	-- b = { desc = "󰓩 Buffers" },
	-- d = { desc = " Debugger" },
	-- S = { desc = "󱂬 Session" },
	-- t = { desc = " Terminal" },
}

require("which-key").register(sections, { prefix = "<leader>" })

local telescope = require("telescope.builtin")
local lazy = require("lazy")

local function telescope_find_all_files()
	telescope.find_files({ hidden = true, no_ignore = true })
end

local function telescope_find_themes()
	telescope.colorscheme({ enable_preview = true })
end

local function telescope_find_words_everywhere()
	telescope.live_grep({
		additional_args = function(args)
			return vim.list_extend(args, { "--hidden", "--no-ignore" })
		end,
	})
end

-- Top Level
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>n", "<cmd>enew q<cr>", { desc = "New File" })
vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

vim.keymap.set("n", "<leader>1", "<cmd>Neotree toggle<cr>", { desc = "Project Files" })

-- Plugin Manager
vim.keymap.set("n", "<leader>pi", lazy.install, { desc = "Plugins Install" })
vim.keymap.set("n", "<leader>ps", lazy.home, { desc = "Plugins Status" })
vim.keymap.set("n", "<leader>pS", lazy.sync, { desc = "Plugins Sync" })
vim.keymap.set("n", "<leader>pu", lazy.check, { desc = "Plugins Check Updates" })
vim.keymap.set("n", "<leader>pU", lazy.update, { desc = "Plugins Update" })
vim.keymap.set("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason Installer" })
vim.keymap.set("n", "<leader>pM", "<cmd>MasonUpdateAll<cr>", { desc = "Mason Update" })

-- Find
vim.keymap.set("n", "<leader>f<CR>", telescope.resume, { desc = "Resume previous search" })
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fF", telescope_find_all_files, { desc = "Find all files" })
vim.keymap.set("n", "<leader>fw", telescope.live_grep, { desc = "Find words" })
vim.keymap.set("n", "<leader>fw", telescope_find_words_everywhere, { desc = "Find words in all files" })
vim.keymap.set("n", "<leader>fc", telescope.grep_string, { desc = "Find for word under cursor" })

vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fC", telescope.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fo", telescope.oldfiles, { desc = "Find history" })
vim.keymap.set("n", "<leader>fr", telescope.registers, { desc = "Find registers" })
vim.keymap.set("n", "<leader>ft", telescope_find_themes, { desc = "Find themes" })

vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>fm", telescope.man_pages, { desc = "Find man pages" })

-- Git
vim.keymap.set("n", "<leader>gb", telescope.git_branches, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", telescope.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gs", telescope.git_status, { desc = "Git status" })
