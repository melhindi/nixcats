local l = require("luasnip.extras").lambda

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

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return {
  -- GENERIC ENVIRONMENT
  s(
    { trig = "new", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH ONE EXTRA ARGUMENT
  s(
    { trig = "n2", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH TWO EXTRA ARGUMENTS
  s(
    { trig = "n3", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{<>}{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        d(4, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- TOPIC ENVIRONMENT (my custom tcbtheorem environment)
  s(
    { trig = "nt", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{topic}{<>}{<>}
            <>
        \end{topic}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  s(
    { trig = "ilg", snippetType = "autosnippet" },
    fmta(
      [[
         \includegraphics[width=0.75\textwidth]{<>}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "dcol", snippetType = "autosnippet" },
    fmta(
      [[
  \begin{columns}
    \begin{column}{<>\textwidth}

    \end{column}
    \begin{column}{<>\textwidth}

    \end{column}
  \end{columns}
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "bcol", snippetType = "autosnippet" },
    fmta(
      [[
         \begin{columns}[T]
         \column{<>\textwidth}
         \justifying
         \column{<>\textwidth}
         \justifying
         \end{columns}
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "bfra", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{frame}{<>}
            <>
        \end{frame}
      ]],
      {
        i(1),
        i(2),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "cha", snippetType = "autosnippet" },
    fmta(
      [[
        \chapter{<>}
        \label{cha:<>}
        <>
      ]],
      {
        i(1),
        l(l._1:gsub(" ", "_"):lower(), 1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "sec", snippetType = "autosnippet" },
    fmta(
      [[
        \section{<>}
        \label{sec:<>}
        <>
      ]],
      {
        i(1),
        l(l._1:gsub(" ", "_"):lower(), 1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "subsec", snippetType = "autosnippet" },
    fmta(
      [[
        \subsection{<>}
        \label{subsec:<>}
        <>
      ]],
      {
        i(1),
        l(l._1:gsub(" ", "_"):lower(), 1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "subsubsec", snippetType = "autosnippet" },
    fmta(
      [[
        \subsubsection{<>}
        \label{subsec:<>}
        <>
      ]],
      {
        i(1),
        l(l._1:gsub(" ", "_"):lower(), 1),
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "par", snippetType = "autosnippet" },
    fmta(
      [[
        \paragraph{<>}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- EQUATION
  s(
    { trig = "nn", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- SPLIT EQUATION
  s(
    { trig = "ss", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{equation*}
            \begin{split}
                <>
            \end{split}
        \end{equation*}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- ALIGN
  s(
    { trig = "all", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{align*}
            <>
        \end{align*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ITEMIZE
  s(
    { trig = "itt", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{itemize}
            \item <>
        \end{itemize}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- ENUMERATE
  s(
    { trig = "enn", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{enumerate}
            \item <>
        \end{enumerate}
      ]],
      {
        i(0),
      }
    )
  ),
  -- INLINE MATH
  s(
    { trig = "([^%l])mm", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>$<>$", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- INLINE MATH ON NEW LINE
  s(
    { trig = "^mm", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("$<>$", {
      i(1),
    })
  ),
  --INKSCAPE FIGURE
  s(
    { trig = "texfig" },
    fmta(
      [[
        \begin{figure}[htb!]
          \centering
            \def\svgwidth{\columnwidth}
            \import{./figures/}{<>.pdf_tex}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
      {
        i(1),
        i(2),
        i(3),
      }
    ),
    { condition = line_begin }
  ),
  -- FIGURE
  s(
    { trig = "fig" },
    fmta(
      [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    ),
    { condition = line_begin }
  ),
}
