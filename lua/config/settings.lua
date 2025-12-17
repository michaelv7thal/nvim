-- General Neovim settings
local opt = vim.opt -- Shorten 'vim.opt' for convenience

-- Line numbers
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers

-- Tabs and indentation
opt.tabstop = 2        -- Number of spaces a <Tab> in the file counts for
opt.shiftwidth = 2     -- Number of spaces used for each step of (auto)indent
opt.expandtab = true   -- Use spaces instead of tabs
opt.smartindent = true -- Auto-indent new lines

-- Search
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true  -- Override ignorecase if search includes uppercase
opt.incsearch = true  -- Show search matches as you type

-- Appearance
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.cursorline = true    -- Highlight the current line

-- Splits
opt.splitbelow = true -- Split window below
opt.splitright = true -- Split window to the right

-- Enable/disable line wrapping
opt.wrap = true

-- Scrolloff and sign column
opt.scrolloff = 8      -- Keep 8 lines visible above/below the cursor
opt.signcolumn = "yes" -- Always show the sign column

-- accept mouse input
opt.mouse = "a"

-- Add colorcolumn incl. setting
opt.colorcolumn = "80"
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=#3b3052]])

opt.winbar = "%f"

-- Best practice: Additional essential settings
opt.backup = false                                  -- Don't create backup files
opt.writebackup = false                             -- Don't create backup before overwriting
opt.swapfile = false                                -- Don't use swap files
opt.undofile = true                                 -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undo"     -- Set undo directory

opt.updatetime = 300                                -- Faster completion and diagnostic updates
opt.timeoutlen = 400                                -- Faster key sequence completion

opt.completeopt = { "menu", "menuone", "noselect" } -- Better completion experience

opt.clipboard = "unnamedplus"                       -- Use system clipboard by default

-- Best practice: Better search experience
opt.hlsearch = true      -- Highlight search results
opt.inccommand = "split" -- Show substitution preview in split

-- Better performance
opt.lazyredraw = false        -- Don't redraw during macros (set to true if experiencing lag)
opt.synmaxcol = 300           -- Limit syntax highlighting for long lines

opt.clipboard = "unnamedplus" --- Use system clipboard
