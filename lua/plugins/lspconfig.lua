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

                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "gu", "<cmd>Telescope lsp_references<CR>", opts)
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
                },
                automatic_installation = true,
            })
        end,
    },
}

