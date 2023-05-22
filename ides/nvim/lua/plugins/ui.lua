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
	{
		"rcarriga/nvim-notify",
	},
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
			},
		},
	},
	{
		"MunifTanjim/nui.nvim",
	},
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				-- add any options here
			})
		end,
		requires = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
}
