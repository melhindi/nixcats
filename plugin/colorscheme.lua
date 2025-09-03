if not nixCats('general') then
  return
end

local colorschemeName = nixCats('colorscheme')
vim.o.background = "dark"
vim.cmd.colorscheme(colorschemeName)
