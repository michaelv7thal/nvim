return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Automatically install/update parsers
    config = function()
        require("nvim-treesitter.configs").setup({
            -- Install languages
            ensure_installed = {
                "lua",       -- Lua
                "vim",       -- Vimscript
                "bash",      -- Bash
                "python",    -- Python
                "javascript",-- JavaScript
                "html",      -- HTML
                "css",       -- CSS
                "json",      -- JSON
                "markdown",  -- Markdown
                "rust",     -- Rus
            },
            highlight = { enable = true },
            incremental_selection = { enable = true },
            indent = { enable = true },
            refactor = { enable = true },
        })
    end,
}
