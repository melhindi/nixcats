if not nixCats('general') then
  return
end

require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

local selection_stacks = {}

local function node_end_position(node)
  local start_row, start_col, end_row, end_col = node:range()

  if end_col > 0 then
    return start_row, start_col, end_row, end_col - 1
  end

  local previous_row = math.max(start_row, end_row - 1)
  local line = vim.api.nvim_buf_get_lines(0, previous_row, previous_row + 1, false)[1] or ''
  return start_row, start_col, previous_row, #line
end

local function select_node(node, push)
  if not node then
    return
  end

  if push then
    local bufnr = vim.api.nvim_get_current_buf()
    selection_stacks[bufnr] = selection_stacks[bufnr] or {}
    table.insert(selection_stacks[bufnr], node)
  end

  local start_row, start_col, end_row, end_col = node_end_position(node)
  vim.cmd('normal! \027')
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd('normal! v')
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
end

local function current_selection_node()
  local stack = selection_stacks[vim.api.nvim_get_current_buf()]
  if stack and #stack > 0 then
    return stack[#stack]
  end

  return vim.treesitter.get_node({ ignore_injections = false })
end

local function init_selection()
  selection_stacks[vim.api.nvim_get_current_buf()] = {}
  select_node(vim.treesitter.get_node({ ignore_injections = false }), true)
end

local function node_incremental()
  local node = current_selection_node()
  if node and node:parent() then
    select_node(node:parent(), true)
  else
    init_selection()
  end
end

local scope_node_types = {
  block = true,
  chunk = true,
  class_declaration = true,
  class_definition = true,
  function_declaration = true,
  function_definition = true,
  function_item = true,
  function_statement = true,
  method_declaration = true,
  method_definition = true,
  module = true,
  source_file = true,
}

local function scope_incremental()
  local node = current_selection_node()
  while node do
    node = node:parent()
    if node and scope_node_types[node:type()] then
      select_node(node, true)
      return
    end
  end
end

local function node_decremental()
  local stack = selection_stacks[vim.api.nvim_get_current_buf()]
  if not stack or #stack <= 1 then
    return
  end

  table.remove(stack)
  select_node(stack[#stack], false)
end

local function incremental_selection()
  if vim.fn.mode():match('[vV]') then
    node_incremental()
  else
    init_selection()
  end
end

vim.keymap.set('n', 'gzi', init_selection, { desc = 'Treesitter node selection' })
vim.keymap.set('x', 'gzi', node_incremental, { desc = 'Treesitter node selection' })
vim.keymap.set('x', 'gzs', scope_incremental, { desc = 'Treesitter scope selection' })
vim.keymap.set('x', 'gzd', node_decremental, { desc = 'Treesitter shrink selection' })

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

vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
  ts_move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })

vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
  ts_move.goto_next_start('@class.outer', 'textobjects')
end, { desc = 'Next class start' })

vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  ts_move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '))', function()
  ts_move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Next function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
  ts_move.goto_next_end('@class.outer', 'textobjects')
end, { desc = 'Next class end' })

vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  ts_move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
  ts_move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
  ts_move.goto_previous_start('@class.outer', 'textobjects')
end, { desc = 'Previous class start' })

vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  ts_move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Previous function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '((', function()
  ts_move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Previous function end' })

vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
  ts_move.goto_previous_end('@class.outer', 'textobjects')
end, { desc = 'Previous class end' })

vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
  ts_move.goto_next('@conditional.outer', 'textobjects')
end, { desc = 'Next conditional' })

vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
  ts_move.goto_previous('@conditional.outer', 'textobjects')
end, { desc = 'Previous conditional' })

vim.keymap.set('n', '<leader>a', function()
  ts_swap.swap_next('@parameter.inner')
end, { desc = 'Swap next parameter' })

vim.keymap.set('n', '<leader>A', function()
  ts_swap.swap_previous('@parameter.inner')
end, { desc = 'Swap previous parameter' })
