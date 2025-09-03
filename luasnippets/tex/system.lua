-- This is the `get_visual` function I've been talking about.
-- ----------------------------------------------------------------------------
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return {
  -- ANNOTATE (custom command for annotating equation derivations)
  s(
    { trig = "ann", snippetType = "autosnippet" },
    fmta(
      [[
      \annotate{<>}{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
      }
    )
  ),
  -- REFERENCE
  s(
    { trig = " RR", snippetType = "autosnippet", wordTrig = false },
    fmta(
      [[
      ~\ref{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- DOCUMENTCLASS
  s(
    { trig = "dcc", snippetType = "autosnippet" },
    fmta(
      [=[
        \documentclass[<>]{<>}
        ]=],
      {
        i(1, "a4paper"),
        i(2, "article"),
      }
    ),
    { condition = line_begin }
  ),
  -- USE A LATEX PACKAGE
  s(
    { trig = "pack", snippetType = "autosnippet" },
    fmta(
      [[
        \usepackage{<>}
        ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- INPUT a LaTeX file
  s(
    { trig = "inn", snippetType = "autosnippet" },
    fmta(
      [[
      \input{<><>}
      ]],
      {
        i(1, "~/dotfiles/config/latex/templates/"),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  -- LABEL
  s(
    { trig = "lbl", snippetType = "autosnippet" },
    fmta(
      [[
      \label{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  -- HPHANTOM
  s(
    { trig = "hpp", snippetType = "autosnippet" },
    fmta(
      [[
      \hphantom{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig = "TODOO", snippetType = "autosnippet" },
    fmta([[\TODO{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    { trig = "nc" },
    fmta([[\newcommand{<>}{<>}]], {
      i(1),
      i(2),
    }),
    { condition = line_begin }
  ),
  s(
    { trig = "sii", snippetType = "autosnippet" },
    fmta([[\si{<>}]], {
      i(1),
    })
  ),
  s(
    { trig = "href", snippetType = "autosnippet" },
    fmta([[\href{<>}{<>}]], {
      i(1, "url"),
      i(2, "desc"),
    })
  ),
  s(
    { trig = "SI" },
    fmta([[\SI{<>}{<>}]], {
      i(1),
      i(2),
    })
  ),
  s(
    { trig = "ct", snippetType = "autosnippet" },
    fmta([[\cite{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    { trig = "crf", snippetType = "autosnippet" },
    fmta([[\Cref{<>}]], {
      d(1, get_visual),
    })
  ),
  s(
    { trig = "url" },
    fmta([[\url{<>}]], {
      d(1, get_visual),
    })
  ),
  -- VSPACE
  s(
    { trig = "vs" },
    fmta([[\vspace{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SECTION
  s(
    { trig = "h1", snippetType = "autosnippet" },
    fmta([[\section{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SUBSECTION
  s(
    { trig = "h2", snippetType = "autosnippet" },
    fmta([[\subsection{<>}]], {
      d(1, get_visual),
    })
  ),
  -- SUBSUBSECTION
  s(
    { trig = "h3", snippetType = "autosnippet" },
    fmta([[\subsubsection{<>}]], {
      d(1, get_visual),
    })
  ),
}
