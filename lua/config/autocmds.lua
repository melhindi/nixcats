local group = vim.api.nvim_create_augroup('UserConfig', { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Format Zig files with zls on save (if it is running, e.g. not in ntex/ntyp)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  pattern = { "*.zig", "*.zon" },
  callback = function(ev)
    if #vim.lsp.get_clients({ bufnr = ev.buf, name = 'zls' }) > 0 then
      vim.lsp.buf.format({ bufnr = ev.buf, name = 'zls' })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "markdown", "rmd", "tex", "text", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
