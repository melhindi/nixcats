if not nixCats('general') then
  return
end

local flash = require("flash")

flash.setup({
  remote_op = {
    restore = true,
    motion = nil,
  },
  modes = {
    treesitter = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      label = {
        before = true,
        after = true,
        style = "inline",
        rainbow = {
          enabled = true,
          shade = 5,
        },
      },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    remote = {
      remote_op = {
        restore = true,
        motion = true,
      },
    },
    treesitter_search = {
      jump = {
        pos = "range",
      },
      search = {
        multi_window = true,
        wrap = true,
        incremental = false,
      },
      remote_op = {
        restore = true,
      },
      label = {
        before = true,
        after = true,
        style = "inline",
        rainbow = {
          enabled = true,
          shade = 5,
        },
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
  flash.treesitter({
    actions = {
      ["<C-Space>"] = "next",
      ["<BS>"] = "prev",
    },
  })
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  flash.remote()
end, { desc = "Remote Flash" })

vim.keymap.set({ "o", "x" }, "R", function()
  flash.treesitter_search()
end, { desc = "Treesitter Search" })

vim.keymap.set("c", "<C-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash Search" })
