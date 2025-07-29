return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        version = "^2.0.0", -- Optional: pin version
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, silent = true, noremap = true }
                local keymap = vim.keymap.set

                keymap("n", "gd", function()
                    local params = vim.lsp.util.make_position_params()
                    vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
                        if err or not result or vim.tbl_isempty(result) then
                            vim.notify("No definition found", vim.log.levels.INFO)
                            return
                        end

                        -- Normalize result: sometimes it's LocationLink[]
                        if vim.tbl_islist(result) and #result == 1 then
                            local location = result[1].targetUri and result[1] or result[1]
                            vim.lsp.util.jump_to_location(location, "utf-8")
                        else
                            require("telescope.builtin").lsp_definitions()
                        end
                    end)
                end, opts)


                keymap("n", "gu", function()
                    local params = vim.lsp.util.make_position_params()
                    params.context = { includeDeclaration = true } -- important: includes declaration site
                    vim.lsp.buf_request(0, "textDocument/references", params, function(err, result)
                        if err or not result or vim.tbl_isempty(result) then
                            vim.notify("No references found", vim.log.levels.INFO)
                            return
                        end

                        -- Always show in Telescope for better navigation context
                        require("telescope.builtin").lsp_references()
                    end)
                end, opts)

                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
                keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                keymap("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            mason_lspconfig.setup({
                ensure_installed = {
                    "pyright",
                    "clangd",
                    "vtsls",
                    "eslint",
                    "rust_analyzer",
                    "html",
                    "cssls",
                    "r_language_server",
                },
                automatic_installation = true,
            })
        end,
    },
}

