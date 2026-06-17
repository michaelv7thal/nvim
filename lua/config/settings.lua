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

-- Headless / devcontainer clipboard via OSC52.
-- `unnamedplus` routes every yank to the `+` register, but a headless box (e.g.
-- inside the devcontainer) has no $DISPLAY and no wl-copy/xclip to back it, and
-- Neovim only auto-enables its built-in OSC52 provider over SSH ($SSH_TTY) — not
-- in a container. So when there's no local display AND no native clipboard tool,
-- drive the system clipboard over OSC52, which reaches the HOST clipboard through
-- the terminal (Ghostty/iTerm2/kitty/wezterm/tmux). On a real desktop session
-- this branch is skipped, leaving the native provider in charge.
local _has_display = vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil
local _has_clip_tool = vim.fn.executable("wl-copy") == 1
  or vim.fn.executable("xclip") == 1
  or vim.fn.executable("xsel") == 1
  or vim.fn.executable("pbcopy") == 1
if not _has_display and not _has_clip_tool then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end

-- vim-tmux-navigator across the devcontainer boundary.
-- The host tmux can't see this nvim in its process list — we run behind
-- `devcontainer exec`, which shows up as node/docker on the host pane — so tmux's
-- default ps-based is_vim check fails and it steals <C-h/j/k/l> for pane switching
-- instead of forwarding them to nvim. Advertise "this is nvim" in-band via the
-- terminal title, which DOES cross the container boundary and lands in tmux's
-- #{pane_title}; the matching tmux is_vim greps for the "nvim:" prefix (see
-- ~/.config/tmux/tmux.conf). Harmless on the host / outside tmux.
opt.title = true
opt.titlestring = "nvim:%t"

-- Best practice: Better search experience
opt.hlsearch = true      -- Highlight search results
opt.inccommand = "split" -- Show substitution preview in split

-- Better performance
opt.lazyredraw = false -- Don't redraw during macros (set to true if experiencing lag)
opt.synmaxcol = 300    -- Limit syntax highlighting for long lines
