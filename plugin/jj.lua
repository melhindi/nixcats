if not nixCats("jj") then
  return
end

-- Read a file exactly as it existed at a jj revision. This is used to build
-- scratch buffers for an ad-hoc diff without checking anything out.
local function file_lines_at_revision(rev, file)
  local lines = vim.fn.systemlist({ "jj", "file", "show", "-r", rev, "--", file })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return lines
end

-- Populate a scratch buffer with revision content and mark it read-only. The
-- buffer name includes the revision so diff tabs remain understandable.
local function set_revision_buffer(buf, rev, file, lines)
  local name = string.format(
    "jj-annotate://%s/%s/%d",
    rev,
    vim.fn.fnamemodify(file, ":."),
    buf
  )

  pcall(vim.api.nvim_buf_set_name, buf, name)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ft = vim.filetype.match({ filename = file })
  if ft then
    vim.bo[buf].filetype = ft
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
end

-- From a jj-nvim annotate line, open a native Vim diff of that revision against
-- its parent. This makes blame/annotate useful as a "why did this line change?"
-- entry point while staying inside Neovim.
local function open_annotated_revision_diff()
  local parser = require("jj.core.parser")
  local parts = parser.parse_annotation_line(vim.api.nvim_get_current_line())

  if not parts or not parts.rev.value or parts.rev.value == "" then
    return
  end

  local file = vim.b.jj_annotation_file
  if not file or file == "" then
    vim.notify("Could not find annotated file", vim.log.levels.ERROR, { title = "JJ" })
    return
  end

  local rev = parts.rev.value
  local parent_rev = rev .. "-"
  local parent_lines = file_lines_at_revision(parent_rev, file) or {}
  local rev_lines = file_lines_at_revision(rev, file)

  if not rev_lines then
    vim.notify("Could not read file at revision " .. rev, vim.log.levels.ERROR, { title = "JJ" })
    return
  end

  -- Prefer a diff algorithm that usually reads better for source changes, then
  -- restore the user's setting when the temporary diff tab is closed.
  local saved_diffopt = vim.o.diffopt
  vim.opt.diffopt:append("algorithm:patience,indent-heuristic")

  vim.cmd("tabnew")
  local parent_buf = vim.api.nvim_get_current_buf()
  set_revision_buffer(parent_buf, parent_rev, file, parent_lines)
  vim.cmd("diffthis")

  vim.cmd("rightbelow vertical new")
  local rev_buf = vim.api.nvim_get_current_buf()
  set_revision_buffer(rev_buf, rev, file, rev_lines)
  vim.cmd("diffthis")

  vim.api.nvim_create_autocmd("TabClosed", {
    once = true,
    callback = function()
      vim.o.diffopt = saved_diffopt
    end,
  })
end

-- Use Neovim's built-in diff view instead of an external diff backend.
require("jj").setup({
  diff = {
    backend = "native",
  },
})

local annotate = require("jj.annotate")
local upstream_annotate_file = annotate.file

-- Extend jj-nvim's annotate command: after it creates the annotate buffer, add
-- a buffer-local <CR> mapping that opens the parent-vs-revision diff above.
annotate.file = function()
  upstream_annotate_file()

  local buf = vim.api.nvim_get_current_buf()
  if not vim.b[buf].jj_annotation_file then
    return
  end

  vim.keymap.set({ "n", "v" }, "<CR>", open_annotated_revision_diff, {
    buffer = buf,
    desc = "Show native revision diff",
    silent = true,
  })
end
