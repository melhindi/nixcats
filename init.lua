-- NOTE: init.lua gets ran before anything else.

-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


require("config.options")
require("config.autocmds")
require("config.keymaps")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader> ', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>?', builtin.current_buffer_fuzzy_find, { desc = 'Telescope fuzzy find buffer' })
vim.keymap.set('n', '<leader>P', builtin.registers, { desc = 'Telescope registers' })
--vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
--vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

