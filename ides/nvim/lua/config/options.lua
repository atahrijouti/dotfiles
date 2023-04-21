vim.api.nvim_exec ('language en_US', true)

vim.opt.termguicolors = true
vim.opt.mouse = "a"

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

vim.opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"

vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true

vim.opt.showtabline = 0
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 300

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.showcmd = true
-- vim.opt.ruler = false                           -- hide the line and column number of the cursor position
vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
-- vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
-- vim.opt.fillchars.eob = " "                     -- show empty lines at the end of a buffer as ` ` {default `~`}


-- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
-- vim.opt.shortmess:append "c"
-- keys allowed to move to the previous/next line when the beginning/end of line is reached
-- vim.opt.whichwrap:append "<,>,[,],h,l"
vim.opt.iskeyword:append "-"
-- vim.opt.formatoptions:remove { "r", "o" }
vim.opt.linebreak = false

vim.opt.wildmode = { "full" }

vim.opt.title = true
vim.opt.emoji = true

vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.foldenable = true

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.history = 1000

vim.opt.preserveindent = true

vim.opt.splitkeep = "screen"
vim.opt.virtualedit = "block"

-- vim.opt.showmode = false
