-- Return snippet tables
return {
  -- main file
  s(
    { trig = "defaultimp", snippetType = "autosnippet" },
    fmta(
      [[
      const std = @import("std");
      const testing = std.testing;
      const assert = std.debug.assert;
      const builtin = @import("builtin");
      ]],
      {}
    ),
    { condition = line_begin }
  ),
}
