if not nixCats('general') then
  return
end

require("yanky").setup()

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before" })
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put after selection" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put before selection" })

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Previous yank entry" })
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next yank entry" })
vim.keymap.set({ "n", "x" }, "<leader>yh", "<cmd>YankyRingHistory<cr>", { desc = "Yank history" })
