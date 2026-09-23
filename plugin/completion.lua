if not nixCats('general') then
  return
end

local luasnip = require 'luasnip'
luasnip.config.setup {
    enable_autosnippets = true,
}
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load() -- luasnippets/ directories on the runtimepath

require("blink.cmp").setup({
  -- Use LuaSnip, so blink lists the snippets in luasnippets/ and <Tab> jumps through
  -- LuaSnip's fields (also those of autosnippets).
  snippets = { preset = 'luasnip' },
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- See :h blink-cmp-config-keymap for configuring keymaps
  -- The preset also maps <Tab>/<S-Tab> to snippet jumps and <C-k> to signature help.
  keymap = { preset = 'default' },
  -- Signature help only on demand with <C-k> in insert mode, not automatically.
  signature = { enabled = true, trigger = { enabled = false } },
})
