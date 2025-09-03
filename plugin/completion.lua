if not nixCats('general') then
  return
end

require("blink.cmp").setup({
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- See :h blink-cmp-config-keymap for configuring keymaps
  keymap = { 
      preset = 'default',
      -- disable a keymap from the preset
      ['<C-k>'] = {},
  }
  })
local luasnip = require 'luasnip'
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "./luasnippets" })
luasnip.config.setup {
    enable_autosnippets = true,
}
