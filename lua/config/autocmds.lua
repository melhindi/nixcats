-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- This disables one of the autoformatting but the other one enables the zls one
vim.g.zig_fmt_autosave = 0
vim.api.nvim_create_autocmd('BufWritePre',{
  pattern = {"*.zig", "*.zon"},
  callback = function(ev)
    vim.lsp.buf.format()
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "rmd", "tex", "text", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
