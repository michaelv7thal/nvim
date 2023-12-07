-- packer plugin manager
require('packer_config')

-- nvim tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Colorscheme
vim.cmd("colorscheme rose-pine")
-- vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]

-- bar settings
require('lualine').setup {
    options = {
        theme = 'rose-pine'
    }
}

-- adjust cwd to current open file

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        -- Change the working directory to the directory of the current file
        vim.cmd "lcd %:p:h"
    end,
})


-- add automatic double quotes and bracing
require('nvim-autopairs').setup {}

-- setup python environment for nvim
vim.g.python3_host_prog= '/Users/michael/.pyenv/versions/3.11.6/bin/python'
