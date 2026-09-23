if not nixCats('general') then
  return
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Incremental selection uses Neovim's built-ins: `v`, then `an`/`in` to grow/shrink
-- to the enclosing/inner node, `[n`/`]n` for siblings; `an`/`in` also work as text
-- objects (e.g. `dan`). Inside flash's `S`, `;`/`,` grow/shrink.

require('nvim-treesitter-textobjects').setup({
  select = {
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v',
      ['@function.outer'] = 'V',
    },
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true,
  },
})

local ts_select = require('nvim-treesitter-textobjects.select')
local ts_move = require('nvim-treesitter-textobjects.move')
local ts_swap = require('nvim-treesitter-textobjects.swap')

vim.keymap.set({ 'x', 'o' }, 'aa', function()
  ts_select.select_textobject('@parameter.outer', 'textobjects')
end, { desc = 'Outer parameter' })

vim.keymap.set({ 'x', 'o' }, 'ia', function()
  ts_select.select_textobject('@parameter.inner', 'textobjects')
end, { desc = 'Inner parameter' })

vim.keymap.set({ 'x', 'o' }, 'af', function()
  ts_select.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Outer function' })

vim.keymap.set({ 'x', 'o' }, 'if', function()
  ts_select.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Inner function' })

vim.keymap.set({ 'x', 'o' }, 'ac', function()
  ts_select.select_textobject('@class.outer', 'textobjects')
end, { desc = 'Outer class' })

vim.keymap.set({ 'x', 'o' }, 'ic', function()
  ts_select.select_textobject('@class.inner', 'textobjects')
end, { desc = 'Inner class' })

vim.keymap.set({ 'x', 'o' }, 'as', function()
  ts_select.select_textobject('@local.scope', 'locals')
end, { desc = 'Local scope' })

vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  ts_move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })

-- In diff mode, keep the built-in ]c/[c (jump to the next/previous change).
vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
  if vim.wo.diff then
    return ']c'
  end
  return "<Cmd>lua require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')<CR>"
end, { expr = true, desc = 'Next class start' })

vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  ts_move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
  ts_move.goto_next_end('@class.outer', 'textobjects')
end, { desc = 'Next class end' })

vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  ts_move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
  if vim.wo.diff then
    return '[c'
  end
  return "<Cmd>lua require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')<CR>"
end, { expr = true, desc = 'Previous class start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  ts_move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Previous function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
  ts_move.goto_previous_end('@class.outer', 'textobjects')
end, { desc = 'Previous class end' })

-- ]I/[I rather than ]d/[d, which are Neovim's diagnostic jumps.
vim.keymap.set({ 'n', 'x', 'o' }, ']I', function()
  ts_move.goto_next('@conditional.outer', 'textobjects')
end, { desc = 'Next conditional' })

vim.keymap.set({ 'n', 'x', 'o' }, '[I', function()
  ts_move.goto_previous('@conditional.outer', 'textobjects')
end, { desc = 'Previous conditional' })

vim.keymap.set('n', '<leader>a', function()
  ts_swap.swap_next('@parameter.inner')
end, { desc = 'Swap next parameter' })

vim.keymap.set('n', '<leader>A', function()
  ts_swap.swap_previous('@parameter.inner')
end, { desc = 'Swap previous parameter' })
