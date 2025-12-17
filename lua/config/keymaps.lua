local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Keybindings for window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = "Move to window below" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = "Move to window above" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = "Move to right window" })

-- Resize splits - Best practice: Use Alt instead of Ctrl to avoid conflicts
vim.keymap.set('n', '<M-Up>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set('n', '<M-Down>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Decrease window height" })
vim.keymap.set('n', '<M-Left>', ':vertical resize -2<CR>',
    { noremap = true, silent = true, desc = "Decrease window width" })
vim.keymap.set('n', '<M-Right>', ':vertical resize +2<CR>',
    { noremap = true, silent = true, desc = "Increase window width" })

-- Terminal mode navigation (using C-w prefix to avoid conflicts)
vim.keymap.set('t', '<C-w>h', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true, desc = "Navigate to left window" })
vim.keymap.set('t', '<C-w>j', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true, desc = "Navigate to window below" })
vim.keymap.set('t', '<C-w>k', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true, desc = "Navigate to window above" })
vim.keymap.set('t', '<C-w>l', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true, desc = "Navigate to right window" })

-- Exit terminal mode (consider using jk or jj instead of Esc if you run vim in terminal)
vim.keymap.set("t", "<C-\\><C-n>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Helper function to determine the working directory
local function get_cwd()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 then
        return git_root
    else
        return vim.fn.getcwd()
    end
end

-- Setup Telescope
telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
            "--column", "--smart-case", "--hidden", "--glob", "!.git/*"
        },
        prompt_prefix = "🔍 ",
        selection_caret = " ",
        path_display = { "smart" },
        mappings = {
            i = { ["<Esc>"] = require("telescope.actions").close },
        },
    },
    pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = function() return { "--hidden" } end },
    },
    extensions = {},
})

-- Key mappings for Telescope
local mappings = {
    { "<leader>ff", function() builtin.find_files({ hidden = true, cwd = "/" }) end,       "Find files (computer root)" },
    { "<leader>fr", function() builtin.find_files({ hidden = true, cwd = get_cwd() }) end, "Find files (cwd or Git root)" },
    { "<leader>fg", function() builtin.live_grep({ cwd = get_cwd() }) end,                 "Live grep (cwd or Git root)" },
    { "<leader>fb", builtin.buffers,                                                       "Search buffers" },
    { "<leader>fh", builtin.help_tags,                                                     "Help tags" },
    { "<leader>ft", builtin.treesitter,                                                    "Treesitter symbols" },
    { "<leader>fm", builtin.marks,                                                         "Marks" },
    { "<leader>fs", builtin.lsp_document_symbols,                                          "Document symbols" },
    { "<leader>fw", builtin.lsp_workspace_symbols,                                         "Workspace symbols" },
    { "<leader>fd", builtin.diagnostics,                                                   "Diagnostics" },
}

for _, map in ipairs(mappings) do
    vim.keymap.set("n", map[1], map[2], { desc = map[3] })
end

-- NVIM Tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Nvim Tree" })

-- Markdown Preview
vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })

-- Terminal keybindings
vim.keymap.set("n", "<leader>th", ":split | term<CR>",
    { noremap = true, silent = true, desc = "Terminal horizontal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>",
    { noremap = true, silent = true, desc = "Terminal vertical split" })
vim.keymap.set("n", "<leader>tt", ":term<CR>", { noremap = true, silent = true, desc = "Terminal fullscreen" })

-- Refactoring Key Mappings
-- Telescope refactoring picker (shows all available refactoring actions)
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
    require("telescope").extensions.refactoring.refactors()
end, { noremap = true, silent = true, desc = "Refactoring menu" })

-- Extract refactorings (visual mode)
vim.keymap.set("x", "<leader>re", function()
    require("refactoring").refactor("Extract Function")
end, { noremap = true, silent = true, desc = "Extract Function" })

vim.keymap.set("x", "<leader>rf", function()
    require("refactoring").refactor("Extract Function To File")
end, { noremap = true, silent = true, desc = "Extract Function To File" })

vim.keymap.set("x", "<leader>rv", function()
    require("refactoring").refactor("Extract Variable")
end, { noremap = true, silent = true, desc = "Extract Variable" })

-- Inline refactorings
vim.keymap.set({ "n", "x" }, "<leader>ri", function()
    require("refactoring").refactor("Inline Variable")
end, { noremap = true, silent = true, desc = "Inline Variable" })

vim.keymap.set("n", "<leader>rI", function()
    require("refactoring").refactor("Inline Function")
end, { noremap = true, silent = true, desc = "Inline Function" })

-- Extract block (normal mode)
vim.keymap.set("n", "<leader>rb", function()
    require("refactoring").refactor("Extract Block")
end, { noremap = true, silent = true, desc = "Extract Block" })

vim.keymap.set("n", "<leader>rbf", function()
    require("refactoring").refactor("Extract Block To File")
end, { noremap = true, silent = true, desc = "Extract Block To File" })

-- Debug operations
vim.keymap.set({ "n", "x" }, "<leader>rp", function()
    require("refactoring").debug.printf({ below = false })
end, { noremap = true, silent = true, desc = "Debug Print" })

vim.keymap.set({ "n", "x" }, "<leader>rdv", function()
    require("refactoring").debug.print_var()
end, { noremap = true, silent = true, desc = "Debug Print Variable" })

vim.keymap.set("n", "<leader>rdc", function()
    require("refactoring").debug.cleanup({})
end, { noremap = true, silent = true, desc = "Debug Cleanup" })

-- System clipboard integration
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true, desc = "Copy line to system clipboard" })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true, desc = "Paste from system clipboard (insert)" })

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

-- File runner
vim.keymap.set("n", "<leader>r", function()
    require("utils.runner").run_file()
end, { noremap = true, silent = true, desc = "Run current file in terminal" })

-- LSP Keybindings (buffer-local, set on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true, noremap = true }

        -- Navigation keymaps
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,
            vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

        -- Hover and signature help
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
        vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help,
            vim.tbl_extend("force", opts, { desc = "Signature help" }))
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
            vim.tbl_extend("force", opts, { desc = "Signature help (insert mode)" }))

        -- Code actions and refactoring
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action (visual)" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

        -- Formatting
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))

        -- Diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
            vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
            vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
        vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist,
            vim.tbl_extend("force", opts, { desc = "Diagnostic list" }))

        -- Workspace management
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
            vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
            vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
    end,
})
