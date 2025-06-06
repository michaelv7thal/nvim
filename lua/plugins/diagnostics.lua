return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Float diagnostics on <leader>e
        vim.keymap.set("n", "<leader>h", function()
            vim.diagnostic.open_float(nil, {
                focus = false,
                border = "rounded",
                source = "always",
                scope = "cursor",
            })
        end, { desc = "Show diagnostic in float" })

        -- Auto-open diagnostic float on CursorHold
        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.diagnostic.open_float(nil, {
                    focus = false,
                    border = "rounded",
                    source = "always",
                    scope = "cursor",
                })
            end,
        })
    end,
}

