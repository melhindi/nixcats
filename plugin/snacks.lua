if not nixCats('general') then
  return
end

require("snacks").setup({
  bigfile = {},
  image = {},
  indent = {},
  notifier = {},
  picker = {},
  rename = {},
  scope = {},
})

vim.keymap.set("n", "<leader> ", function()
  Snacks.picker.smart({ filter = { cwd = true } })
end, { desc = "Smart find files" })

vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

vim.keymap.set("n", "<leader>?", function()
  Snacks.picker.grep_buffers()
end, { desc = "Grep open buffers" })

vim.keymap.set("n", '<leader>"', function()
  Snacks.picker.registers()
end, { desc = "Registers" })

vim.keymap.set("n", "<leader>.", function()
  Snacks.picker.lines()
end, { desc = "Buffer lines" })

vim.keymap.set("n", "<leader>,", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>k", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
