if not nixCats('general') then
    return
end

local rnvim = require('r')
rnvim.setup({
    R_args = {'--no-save', '--no-restore'},
    hook = {
        on_filetype = function ()
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendParagraph", {})
        end
    },
})
