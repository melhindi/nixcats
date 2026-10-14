if not nixCats('typst') then
  return
end

-- nixpkgs patches in the tinymist and websocat paths, so nothing gets downloaded.
require('typst-preview').setup({})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user-typst', { clear = true }),
  pattern = 'typst',
  callback = function(ev)
    vim.keymap.set('n', '<leader>tp', '<cmd>TypstPreviewToggle<cr>', { buffer = ev.buf, desc = 'Toggle typst preview' })
    vim.keymap.set('n', '<leader>tf', '<cmd>TypstPreviewFollowCursorToggle<cr>', { buffer = ev.buf, desc = 'Toggle preview follow cursor' })
  end,
})
