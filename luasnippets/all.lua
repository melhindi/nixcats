-- Place this in ${HOME}/.config/nvim/LuaSnip/all.lua

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(args, parent, cmd)
   local command = cmd .. " " .. args[1][1]
   local file = io.popen(command, "r")
   local res = {}
   for line in file:lines() do
      table.insert(res, line)
   end
   return res
end

return {
}
--, { t("figure name folder: "), i(1), t("sub-folder(optional)"), i(2), f(bash, { 1 }, { user_args = { "cfig" } }) }),
