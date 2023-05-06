return {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		tag = "release",
		ft = "gitcommit",
		config = function()
			require("gitsigns").setup()
		end,
	},
}
