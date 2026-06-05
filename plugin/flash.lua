if not nixCats('general') then
  return
end

local flash = require("flash")

flash.setup({
  modes = {
    treesitter = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      label = {
        before = true,
        after = true,
        style = "inline",
      },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
  },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  flash.treesitter()
end, { desc = "Flash treesitter" })

vim.keymap.set("o", "r", function()
  flash.remote()
end, { desc = "Remote flash" })

vim.keymap.set({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, { desc = "Treesitter search" })
