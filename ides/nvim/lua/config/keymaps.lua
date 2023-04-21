vim.g.mapleader = " "
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit"})
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save"})


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = "Find words" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
