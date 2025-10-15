-- Set leader keys BEFORE loading lazy.nvim (CRITICAL!)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load lazy.nvim setup
require("config.lazy")

-- Load basic settings
require("config.settings")

-- Load keymaps
require("config.keymaps")
