vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.neovide_cursor_animation_length = 0
vim.o.guifont = "JetBrainsMono Nerd Font:h10"

vim.api.nvim_exec("language en_US", true)

vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"
vim.opt.showtabline = 0
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.showcmd = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.history = 1000
vim.opt.linebreak = false
vim.opt.title = true
vim.opt.emoji = true
vim.opt.splitkeep = "screen"
vim.opt.virtualedit = "block"
vim.opt.whichwrap = "b,s,h,l"
-- local history
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.swapfile = false

-- backup
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- search
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true

-- indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.preserveindent = true

-- folds
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"

-- complex modifications
vim.opt.iskeyword:append("-")

vim.opt.formatoptions = "jcroqlnt"

vim.opt.wildmode = { "full" }

vim.opt.completeopt = { "menuone", "noselect" }
