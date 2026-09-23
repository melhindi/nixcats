-- Zig autosnippets, triggered with a `;` prefix. They only expand in code, not inside
-- comments, string/char literals or multiline strings. For debug prints, see `zprint`
-- in functions.lua.

local function in_zig_code(line_to_cursor)
  -- Zig comments and quoted literals are line-local; multiline string lines start
  -- with \\. Scan the typed prefix to also handle unfinished literals.
  local quote
  local index = 1
  while index <= #line_to_cursor do
    local char = line_to_cursor:sub(index, index)
    local pair = line_to_cursor:sub(index, index + 1)
    if quote then
      if char == "\\" then
        index = index + 1
      elseif char == quote then
        quote = nil
      end
    elseif pair == "//" or pair == "\\\\" then
      return false
    elseif char == '"' or char == "'" then
      quote = char
    end
    index = index + 1
  end
  return quote == nil
end

local function auto(trigger, name, nodes)
  return s({
    trig = trigger,
    name = name,
    snippetType = "autosnippet",
    wordTrig = true,
    condition = in_zig_code,
  }, nodes)
end

return {
  auto(";imp", "Import", {
    t("const "), i(1, "name"), t(' = @import("'), i(2, "module"), t('");'), i(0),
  }),
  auto(";fn", "Function", {
    t("fn "), i(1, "name"), t("("), i(2, "params"), t(") "), i(3, "void"),
    t({ " {", "\t" }), i(4), t({ "", "}" }), i(0),
  }),
  auto(";pfn", "Public function", {
    t("pub fn "), i(1, "name"), t("("), i(2, "params"), t(") "), i(3, "!void"),
    t({ " {", "\t" }), i(4), t({ "", "}" }), i(0),
  }),
  auto(";test", "Test", {
    t('test "'), i(1, "description"), t({ '" {', "\t" }), i(2), t({ "", "}" }), i(0),
  }),
  auto(";st", "Struct", {
    t("const "), i(1, "Name"), t({ " = struct {", "\t" }), i(2), t({ "", "};" }), i(0),
  }),
  auto(";en", "Enum", {
    t("const "), i(1, "Name"), t({ " = enum {", "\t" }), i(2), t({ "", "};" }), i(0),
  }),
  auto(";if", "If", {
    t("if ("), i(1, "condition"), t({ ") {", "\t" }), i(2), t({ "", "}" }), i(0),
  }),
  auto(";opt", "Optional capture", {
    t("if ("), i(1, "optional"), t(") |"), i(2, "value"),
    t({ "| {", "\t" }), i(3), t({ "", "}" }), i(0),
  }),
  auto(";for", "For loop", {
    t("for ("), i(1, "items"), t(") |"), i(2, "item"),
    t({ "| {", "\t" }), i(3), t({ "", "}" }), i(0),
  }),
  auto(";idx", "For loop with index", {
    t("for ("), i(1, "items"), t(", 0..) |"), i(2, "item"), t(", "), i(3, "index"),
    t({ "| {", "\t" }), i(4), t({ "", "}" }), i(0),
  }),
  auto(";wh", "While loop", {
    t("while ("), i(1, "condition"), t({ ") {", "\t" }), i(2), t({ "", "}" }), i(0),
  }),
  auto(";sw", "Switch", {
    t("switch ("), i(1, "value"), t({ ") {", "\t" }), i(2), t({ "", "}" }), i(0),
  }),
}
