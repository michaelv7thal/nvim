return {
    "neovim/nvim-lspconfig",
    config = function()
        -- Float diagnostics under cursor (border/source come from vim.diagnostic.config)
        vim.keymap.set("n", "<leader>h", function()
            vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
        end, { desc = "Show diagnostic in float" })

        -- Auto-open diagnostic float on CursorHold
        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
            end,
        })
    end,
}

