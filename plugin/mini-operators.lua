if not nixCats('general') then
  return
end

-- Exchange on gX instead of gx, so gx keeps opening URLs/files
require("mini.operators").setup({
  exchange = { prefix = "gX" },
})
