-- Return snippet tables
return {
  -- main file
  s(
    { trig = "zprint", snippetType = "autosnippet" },
    fmta(
      [[
      std.debug.print("<>\n", .{<>});
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
}
