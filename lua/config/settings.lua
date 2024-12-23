-- General Neovim settings
local opt = vim.opt		    -- Shorten 'vim.opt' for convenience

-- Line numbers
opt.number = true		    -- Show line numbers
opt.relativenumber = true	-- Show relative line numbers

-- Tabs and indentation
opt.tabstop = 4			    -- Number of spaces a <Tab> in the file counts for
opt.shiftwidth = 4		    -- Number of spaces used for each step of (auto)indent
opt.expandtab = true		-- Use spaces instead of tabs
opt.smartindent = true		-- Auto-indent new lines

-- Search
opt.ignorecase = true		-- Ignore case in search patterns
opt.smartcase = true		-- Override ignorecase if search includes uppercase
opt.incsearch = true		-- Show search matches as you type

-- Appearance
opt.termguicolors = true	-- Enable 24-bit RGB colors
opt.cursorline = true		-- Highlight the current line

-- Splits
opt.splitbelow = true		-- Split window below
opt.splitright = true		-- Split window to the right

-- Enable/disable line wrapping
opt.wrap = true

-- Scrolloff and sign column
opt.scrolloff = 8		    -- Keep 8 lines visible above/below the cursor
opt.signcolumn = "yes"		-- Always show the sign column

-- accept mouse input
opt.mouse = "a"

-- Add colorcolumn incl. setting
opt.colorcolumn = "80"
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=#3b3052]])

opt.winbar = "%f"



