-- Return snippet tables
return {
  -- main file
  s(
    { trig = "main", snippetType = "autosnippet" },
    fmta(
      [[
      int main(int argc, char *argv[])
      {
      <>
      }
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "gmain", snippetType = "autosnippet" },
    fmta(
      [[
      int main(int argc, char *argv[])
      {
      gflags::SetUsageMessage("<>");
      gflags::ParseCommandLineFlags(&argc, &argv, true);
      <>
      }
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
}
