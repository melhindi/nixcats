-- Return snippet tables
return {
  -- main file
  s(
    { trig = "ssql", snippetType = "autosnippet" },
    fmta(
      [[
      <> <<- sqldf("SELECT <> FROM <>;")
      ]],
      {
        i(1, "newdf"),
        i(2, "*"),
        i(3, "df"),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "rcsv", snippetType = "autosnippet" },
    fmta(
      [[
      <> <<- read.csv("<>")
      ]],
      {
        i(1, "df"),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
}
