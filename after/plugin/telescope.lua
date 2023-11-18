-- Telescope setting and keybinding

require('telescope').setup {
    defaults = {
    },
    pickers = {

        find_files = {
            find_command = {'rg', '--ignore', '--hidden', '--files'}
        }

    }
}



vim.api.nvim_set_keymap('n', '<leader>f', 
    "<cmd>lua require('telescope.builtin').find_files({ search_dirs = {'~/Documents', '~/Desktop', '~/.config'} })<CR>", 
    {noremap = true, silent = true})
