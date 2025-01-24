local telescope = require('telescope')
local builtin = require('telescope.builtin')

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
}

for _, map in ipairs(mappings) do
    vim.keymap.set("n", map[1], map[2], { desc = map[3] })
end

-- NVIM Tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Nvim Tree" })

vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })

-- Keybindings for terminal navigation and resizing
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true }) -- Move to the left split
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true }) -- Move to the below split
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true }) -- Move to the above split
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true }) -- Move to the right split

-- Resize splits
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true })    -- Increase height
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true })  -- Decrease height
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true }) -- Decrease width
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true }) -- Increase width

-- Terminal mode navigation (requires nvim terminal)
vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true }) -- Left split
vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true }) -- Down split
vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true }) -- Up split
vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true }) -- Right split

-- Keybinding to open a terminal in horizontal split
vim.api.nvim_set_keymap("n", "<leader>th", ":split | term<CR>", { noremap = true, silent = true })

-- Keybinding to open a terminal in vertical split
vim.api.nvim_set_keymap("n", "<leader>tv", ":vsplit | term<CR>", { noremap = true, silent = true })

-- Keybinding to open a terminal in fullscreen
vim.api.nvim_set_keymap("n", "<leader>tt", ":term<CR>", { noremap = true, silent = true })

-- Toggle between terminal and normal mode
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true }) -- Exit terminal mode
vim.api.nvim_set_keymap("t", "<C-w>h", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true }) -- Navigate to left split
vim.api.nvim_set_keymap("t", "<C-w>j", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true }) -- Navigate to down split
vim.api.nvim_set_keymap("t", "<C-w>k", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true }) -- Navigate to up split
vim.api.nvim_set_keymap("t", "<C-w>l", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true }) -- Navigate to right split


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


-- copy paste keymaps
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })

vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true })

