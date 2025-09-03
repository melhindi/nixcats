-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.background = "light"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvimbackups"
vim.opt.undofile = true
vim.opt.updatetime = 750
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }
vim.opt.clipboard = "unnamedplus"


vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
