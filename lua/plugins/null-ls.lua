-- plugins/null-ls.lua
return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- Example: Add formatters and linters
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.formatting.rustfmt,
                null_ls.builtins.formatting.csharpier,
                null_ls.builtins.formatting.clang_format,
                null_ls.builtins.diagnostics.clang_check,
            },
            on_attach = function(client, bufnr)
                local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                -- Enable format on save
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })
    end,
}

