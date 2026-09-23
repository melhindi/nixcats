-- Markdown autosnippets, triggered with a `;` prefix. They only expand in prose, not
-- inside fenced/indented code blocks or inline code.

local function in_prose()
  -- Parse the latest typed text, including unfinished fences. If the Markdown parser
  -- is unavailable, leave the trigger as ordinary text.
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
  if not ok or not parser then
    return false
  end
  local cursor = vim.api.nvim_win_get_cursor(0)
  local pos = { cursor[1] - 1, math.max(cursor[2] - 1, 0) }
  parser:parse({ pos[1], pos[1] + 1 })

  local node = vim.treesitter.get_node({ pos = pos, ignore_injections = true })
  while node do
    if node:type() == "fenced_code_block" or node:type() == "indented_code_block" then
      return false
    end
    node = node:parent()
  end

  node = vim.treesitter.get_node({ pos = pos, ignore_injections = false })
  while node do
    if node:type() == "code_span" then
      return false
    end
    node = node:parent()
  end
  return true
end

-- `line_start` snippets only expand when the trigger is the first text on the line.
local function auto(trigger, name, nodes, line_start)
  return s({
    trig = trigger,
    name = name,
    snippetType = "autosnippet",
    wordTrig = true,
    condition = function(line_to_cursor, matched_trigger)
      if line_start and not line_to_cursor:sub(1, #line_to_cursor - #matched_trigger):match("^%s*$") then
        return false
      end
      return in_prose()
    end,
  }, nodes)
end

-- Keep triggers prefix-free: e.g. `;i` would fire before `;ic` or `;img` is complete.
return {
  auto(";hl", "Hyperlink", { t("["), i(1, "text"), t("]("), i(2, "url"), t(")"), i(0) }),
  auto(";img", "Image", { t("!["), i(1, "alt text"), t("]("), i(2, "path"), t(")"), i(0) }),
  auto(";cb", "Code block", {
    t("```"), i(1, "language"), t({ "", "" }), i(2, "code"), t({ "", "```", "" }), i(0),
  }, true),
  auto(";ic", "Inline code", { t("`"), i(1, "code"), t("`"), i(0) }),
  auto(";b", "Bold", { t("**"), i(1, "text"), t("**"), i(0) }),
  auto(";em", "Italic", { t("*"), i(1, "text"), t("*"), i(0) }),
  auto(";todo", "Task", { t("- [ ] "), i(1, "task"), i(0) }, true),
  auto(";tbl", "Table", {
    t("| "), i(1, "Column 1"), t(" | "), i(2, "Column 2"),
    t({ " |", "| --- | --- |", "| " }), i(3, "Value 1"), t(" | "), i(4, "Value 2"),
    t({ " |", "" }), i(0),
  }, true),
}
