local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Keybindings for window navigation and resizing
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = "Move to window below" })
-- Note: <C-k> reserved for LSP signature help
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = "Move to right window" })

-- Helper function to determine the working directory
local function get_cwd()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 then
        return git_root -- Use Git root if available
    else
        return vim.fn.getcwd() -- Otherwise, fallback to current directory
    end
end

-- Setup Telescope
telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
            "--column", "--smart-case", "--hidden", "--glob", "!.git/*" -- Include hidden files, exclude .git
        },
        prompt_prefix = "🔍 ",
        selection_caret = " ",
        path_display = { "smart" },
        mappings = {
            i = { ["<Esc>"] = require("telescope.actions").close }, -- Close with Esc in insert mode
        },
    },
    pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = function() return { "--hidden" } end },
    },
    extensions = {
        -- Add extensions here (e.g., fzf, file_browser)
    },
})

-- Key mappings for Telescope
local mappings = {
    -- Search all files from the computer root
    { "<leader>ff", function() builtin.find_files({ hidden = true, cwd = "/" }) end, "Find files (computer root)" },

    -- Search files from the current folder or Git root
    { "<leader>fr", function() builtin.find_files({ hidden = true, cwd = get_cwd() }) end, "Find files (cwd or Git root)" },

    -- Live grep from the current folder or Git root
    { "<leader>fg", function() builtin.live_grep({ cwd = get_cwd() }) end, "Live grep (cwd or Git root)" },

    -- Search open buffers
    { "<leader>fb", builtin.buffers, "Search buffers" },

    -- Search Neovim help tags
    { "<leader>fh", builtin.help_tags, "Help tags" },

    -- Search Treesitter symbols
    { "<leader>ft", builtin.treesitter, "Treesitter symbols" },

    -- Search marks in the current session
    { "<leader>fm", builtin.marks, "Marks" },
    
    -- Best practice: LSP-specific Telescope pickers
    { "<leader>fs", builtin.lsp_document_symbols, "Document symbols" },
    { "<leader>fw", builtin.lsp_workspace_symbols, "Workspace symbols" },
    { "<leader>fd", builtin.diagnostics, "Diagnostics" },
}

for _, map in ipairs(mappings) do
    vim.keymap.set("n", map[1], map[2], { desc = map[3] })
end

-- NVIM Tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Nvim Tree" })

vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })

local telescope = require('telescope')
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = "Move to window below" })
-- Note: <C-k> conflicts with LSP signature help, using <C-Up> for window navigation if needed
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = "Move to right window" })

-- Resize splits - Best practice: Use Alt instead of Ctrl to avoid conflicts
vim.keymap.set('n', '<M-Up>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set('n', '<M-Down>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set('n', '<M-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true, desc = "Decrease window width" })
vim.keymap.set('n', '<M-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true, desc = "Increase window width" })

-- Terminal mode navigation
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true, desc = "Move to window below" })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true, desc = "Move to right window" })

-- Terminal keybindings
vim.keymap.set("n", "<leader>th", ":split | term<CR>", { noremap = true, silent = true, desc = "Terminal horizontal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>", { noremap = true, silent = true, desc = "Terminal vertical split" })
vim.keymap.set("n", "<leader>tt", ":term<CR>", { noremap = true, silent = true, desc = "Terminal fullscreen" })

-- Exit terminal mode easily
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true, desc = "Navigate to left window" })
vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true, desc = "Navigate to window below" })
vim.keymap.set("t", "<C-w>k", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true, desc = "Navigate to window above" })
vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true, desc = "Navigate to right window" })


-- Refactoring Key Mappings
vim.keymap.set("x", "<leader>re", function() require('refactoring').refactor('Extract Function') end, { noremap = true, silent = true })
vim.keymap.set("x", "<leader>rf", function() require('refactoring').refactor('Extract Function To File') end, { noremap = true, silent = true })
-- Extract Function supports only visual mode

vim.keymap.set("x", "<leader>rv", function() require('refactoring').refactor('Extract Variable') end, { noremap = true, silent = true })
-- Extract Variable supports only visual mode

vim.keymap.set("n", "<leader>rI", function() require('refactoring').refactor('Inline Function') end, { noremap = true, silent = true })
-- Inline Function supports only normal mode

vim.keymap.set({ "n", "x" }, "<leader>ri", function() require('refactoring').refactor('Inline Variable') end, { noremap = true, silent = true })
-- Inline Variable supports both normal and visual mode

vim.keymap.set("n", "<leader>rb", function() require('refactoring').refactor('Extract Block') end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rbf", function() require('refactoring').refactor('Extract Block To File') end, { noremap = true, silent = true })
-- Extract Block supports only normal mode


-- Best practice: System clipboard integration
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true, desc = "Copy line to system clipboard" })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true, desc = "Paste from system clipboard (insert)" })

-- Best practice: Additional useful keymaps
-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })

-- Move lines up and down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Better window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { noremap = true, silent = true, desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { noremap = true, silent = true, desc = "Make windows equal size" })
vim.keymap.set("n", "<leader>sx", ":close<CR>", { noremap = true, silent = true, desc = "Close current window" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

-- Clear search highlighting
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- Save and quit shortcuts
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true, desc = "Quit all without saving" })

