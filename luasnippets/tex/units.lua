--Here we define units that are used with the siunitx package
return {
  s(
    { trig = "siBB", wordTrig = true, regTrig = true, snippetType = "autosnippet" },
    fmta("\\SI{<>}{\\byte}", {
      i(1),
    })
  ),
  s(
    { trig = "siKB", wordTrig = true, regTrig = true, snippetType = "autosnippet" },
    fmta("\\SI{<>}{\\kilo\\byte}", {
      i(1),
    })
  ),
  s(
    { trig = "siMB", wordTrig = true, regTrig = true, snippetType = "autosnippet" },
    fmta("\\SI{<>}{\\mega\\byte}", {
      i(1),
    })
  ),
  s(
    { trig = "siGB", wordTrig = true, regTrig = true, snippetType = "autosnippet" },
    fmta("\\SI{<>}{\\giga\\byte}", {
      i(1),
    })
  ),
  s(
    { trig = "siTB", wordTrig = true, regTrig = true, snippetType = "autosnippet" },
    fmta("\\SI{<>}{\\tera\\byte}", {
      i(1),
    })
  ),
}
