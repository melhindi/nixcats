if not nixCats('general') then
  return
end

local servers = {}

-- Note: Add language servers here
if nixCats('latex') then
  servers.texlab = {}
end
if nixCats('zig') then
  servers.zls = {}
end
if nixCats('rPlugin') then
  servers.r_language_server = {}
end
servers.nixd = {}
servers.lua_ls = {}

local lspconfig = require('lspconfig')
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    capabilities = require('blink.cmp').get_lsp_capabilities({}, true),
    on_attach = function(_, bufnr)
      -- we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end
      local telescope = require("telescope.builtin");
      nmap('<leader>cn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('<leader>d', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>r', telescope.lsp_references, '[G]oto [R]eferences')
      nmap('<leader>i', telescope.lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>s', telescope.symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws',  telescope.lsp_workspace_symbols , '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end,
  }
)
-- set up the servers to be loaded on the appropriate filetypes!
for server_name, cfg in pairs(servers) do
  lspconfig[server_name].setup(cfg or {})
end

