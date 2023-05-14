local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
  },
  change_detection = {
    enabled = false,
    notify = true,
  },
  install = {
    colorscheme = { "tokyonight" },
  },
  performance = {
    disable_plugins = {
      "gzip",
      "tarPlugin",
      "tohtml",
      "zipPlugin",
    },
  },
})
