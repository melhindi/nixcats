vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.background = "dark"
vim.opt.swapfile = false
vim.opt.backup = false
local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undodir = undo_dir
vim.fn.mkdir(undo_dir, "p")
vim.opt.undofile = true
vim.opt.updatetime = 750
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitkeep = "screen"
vim.opt.jumpoptions = "view" -- restore the view (scroll position) when jumping back
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.virtualedit = "block" -- allow the cursor past the end of lines in visual block mode


vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
