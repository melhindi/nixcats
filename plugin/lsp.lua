if not nixCats('general') then
  return
end

local servers = {}

-- Note: Add language servers here
if nixCats('python') then
  servers.basedpyright = {}
end
if nixCats('rust') then
  servers.rust_analyzer = {}
end
if nixCats('latex') then
  servers.texlab = {}
end
if nixCats('typst') then
  servers.tinymist = {}
end
if nixCats('zig') then
  servers.zls = {}
end
if nixCats('rPlugin') then
  -- R.nvim's built-in server handles completion, hover, etc. (see :h R-language-server),
  -- so the languageserver package is only used for what remains, mainly lintr diagnostics.
  local r_ls_options = [[options(languageserver.server_capabilities = list(
    hoverProvider = FALSE, signatureHelpProvider = FALSE, completionProvider = FALSE,
    completionItemResolve = FALSE, definitionProvider = FALSE, referencesProvider = FALSE,
    implementationProvider = FALSE, documentHighlightProvider = FALSE,
    documentSymbolProvider = FALSE, workspaceSymbolProvider = FALSE, renameProvider = FALSE))]]

  -- languageserver comes from the R on PATH (profile or project devShell), which may not
  -- have it. Check once per R binary, asynchronously so opening a file never blocks.
  local has_languageserver = {} -- R path -> true | false | list of waiting callbacks
  local function with_languageserver(callback)
    local r = vim.fn.exepath('R')
    if r == '' then
      return
    end
    local state = has_languageserver[r]
    if state == true then
      return callback()
    elseif state == false then
      return
    elseif state then
      return table.insert(state, callback)
    end
    has_languageserver[r] = { callback }
    local check = 'quit(status = if (requireNamespace("languageserver", quietly = TRUE)) 0 else 1)'
    vim.system({ r, '--no-echo', '-e', check }, { timeout = 10000 }, function(obj)
      vim.schedule(function()
        local waiting = has_languageserver[r]
        has_languageserver[r] = obj.code == 0
        if obj.code == 0 then
          for _, cb in ipairs(waiting) do
            cb()
          end
        end
      end)
    end)
  end

  servers.r_language_server = {
    cmd = { 'R', '--no-echo', '-e', r_ls_options .. '; languageserver::run()' },
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      if fname == '' then
        return
      end
      with_languageserver(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        -- Fall back to the file's directory, not $HOME: languageserver indexes the
        -- whole workspace before it publishes diagnostics.
        local root = vim.fs.root(bufnr, function(name)
          return name == '.git' or name == 'DESCRIPTION' or name:match('%.Rproj$') ~= nil
        end)
        on_dir(root or vim.fs.dirname(fname))
      end)
    end,
  }
end
servers.nixd = {}
servers.lua_ls = {}

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities({}, true),
})

-- Keymaps via LspAttach, so they also apply to clients started with vim.lsp.start()
-- instead of vim.lsp.enable(), e.g. R.nvim's built-in r_ls.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf

    -- create a function to more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then desc = 'LSP: ' .. desc end
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>cn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('<leader>d', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>r', function()
      Snacks.picker.lsp_references()
    end, '[G]oto [R]eferences')
    nmap('<leader>i', function()
      Snacks.picker.lsp_implementations()
    end, '[G]oto [I]mplementation')

    nmap('<leader>s', function()
      Snacks.picker.lsp_symbols()
    end, '[D]ocument [S]ymbols')
    nmap('<leader>ws', function()
      Snacks.picker.lsp_workspace_symbols()
    end, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

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
})

-- Server-specific configs + enable by filetype
-- `servers` should be a table like: { lua_ls = {settings=...}, pyright = {}, ... }
for name, cfg in pairs(servers) do
  if cfg and next(cfg) ~= nil then
    -- Merge/override defaults for this server
    vim.lsp.config(name, cfg)
  end
  -- Activate (auto-starts on matching filetypes/root)
  vim.lsp.enable(name)
end
