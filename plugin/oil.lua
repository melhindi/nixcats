if not nixCats('general') then
  return
end

require("oil").setup()

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
