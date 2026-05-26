if not nixCats('general') then
  return
end

local colorschemeName = nixCats('colorscheme')
vim.cmd.colorscheme(colorschemeName)
