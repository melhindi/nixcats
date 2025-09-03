-- Return snippet tables
return {
  -- main file
  s(
    { trig = "var gpa", snippetType = "autosnippet" },
    fmta(
      [[
      var gpa = std.heap.GeneralPurposeAllocator(.{}){};
      defer _ = gpa.deinit();
      const allocator = gpa.allocator();
      ]],
      {}
    ),
    { condition = line_begin }
  ),
}
