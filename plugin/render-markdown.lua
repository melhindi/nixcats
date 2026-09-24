if not nixCats('general') then
  return
end

-- R.nvim registers this too, but only in variants that include it.
vim.treesitter.language.register('markdown', { 'rmd', 'quarto' })

require('render-markdown').setup({
  file_types = { 'markdown', 'rmd', 'quarto' },
  -- Callout and checkbox completions through an in-process LSP, picked up by blink.cmp.
  completions = { lsp = { enabled = true } },
  -- Math needs an external converter (utftex or latex2text), which is not installed.
  latex = { enabled = false },
})

vim.keymap.set('n', '<leader>um', function()
  require('render-markdown').buf_toggle()
end, { desc = 'Toggle markdown rendering' })

vim.keymap.set('n', '<leader>uM', function()
  require('render-markdown').preview()
end, { desc = 'Markdown preview in side split' })
