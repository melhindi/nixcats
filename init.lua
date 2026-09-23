-- NOTE: init.lua gets ran before anything else.

-- NOTE: nixCats compatibility shim: plugin/*.lua use nixCats('category').
-- Categories are passed from module.nix via info.categories.
local has_nix_info, nix_info = pcall(require, vim.g.nix_info_plugin_name or "nix-info")
_G.nixCats = function(cat)
  if not has_nix_info then
    return false
  end
  return nix_info(nil, "info", "categories", cat)
end

-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


require("config.options")
require("config.autocmds")
require("config.keymaps")


