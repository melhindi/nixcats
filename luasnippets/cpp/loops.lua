-- Return snippet tables
return {
  -- main file
  s(
    { trig = "afor", snippetType = "autosnippet" },
    fmta(
      [[
      for(auto& <> : <>){
         <>
      }
      ]],
      {
        i(1),
        i(2),
        i(3),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "ifor", snippetType = "autosnippet" },
    fmta(
      [[
      for(<> <>;<> << <>; <>++){
         <>
      }
      ]],
      {
        i(1, "size_t"),
        i(2, "i"),
        rep(2),
        i(3),
        rep(2),
        i(4),
      }
    ),
    { condition = line_begin }
  ),
}
