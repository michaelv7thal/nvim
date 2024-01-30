-- Key Mappings
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


-- adjust window sizes
vim.api.nvim_set_keymap('n', '<A-Up>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Down>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- equalize window sizes
vim.api.nvim_set_keymap('n', '<Leader><S-=>', ':wincmd =<CR>', { noremap = true, silent = true })

-- move betweend windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- add keybinding for tagbar
vim.api.nvim_set_keymap('n', '<leader>T', ':Tagbar<CR>', { silent = true })
