-- NOTE: init.lua gets ran before anything else.

-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


require("config.options")
require("config.autocmds")
require("config.keymaps")


