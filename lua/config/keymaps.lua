local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Better escape using Ctr-C in insert mode
keymap("i", "<C-c>", "<ESC>", default_opts)

-- Center search results
keymap("n", "n", "nzz", default_opts)
keymap("n", "N", "Nzz", default_opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move cursor when line wrap is activated
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

-- Cancel search highlighting with ESC -- not required for nvim lazy starterTemplate
keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_opts)

-- home row jump beginning and end of line
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

-- Replace word under curser in document
vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {desc = "Replace word under cursor in doc"})

--- Evaluate line as shell command
vim.keymap.set("n", "<leader><CR>", ":.!bash<CR>", {desc = "Evaluate line as shell cmd"})

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- switch buffer
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete current Buffer" })

-- lsp keymaps
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP Rename" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP Code Action" })

-- correct spelling
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { noremap = true })

-- numbered moves to jump list
vim.keymap.set({ "n", "x" }, "j", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader> ', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>?', builtin.current_buffer_fuzzy_find, { desc = 'Telescope fuzzy find buffer' })
vim.keymap.set('n', '<leader>"', builtin.registers, { desc = 'Telescope registers' })
vim.keymap.set('n', '<leader>.', builtin.current_buffer_fuzzy_find, { desc = 'Telescope fuzzy find buffer' })
vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = 'Telescope buffers' })
--        { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep Files" },
local neotree = require('neo-tree.command')
vim.keymap.set('n', '<leader>e', function() neotree.execute({toggle = true}) end, {desc = "Explorer NeoTree (Root Dir)"})
vim.keymap.set('n', '<leader>E', function() neotree.execute({toggle = true, dir = vim.uv.cwd()}) end, {desc = "Explorer NeoTree (cwd)"})
-- { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },

--vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
