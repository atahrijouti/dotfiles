require("config.options")
require("config.lazy")

vim.api.nvim_create_augroup("lazy", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = "lazy",
	pattern = "VeryLazy",
	callback = function()
		require("config.autocommands")
		require("config.keymaps")
	end,
})
