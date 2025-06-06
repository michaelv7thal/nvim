return {
    -- LSP setup with mason
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local keymap = vim.keymap.set
                local opts = { buffer = bufnr, silent = true, noremap = true }

                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "gu", "<cmd>Telescope lsp_references<CR>", opts)
                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
                keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                keymap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
            end

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "clangd",
                    "vtsls",
                    "eslint",
                    "rust_analyzer",
                },
                automatic_installation = true,
            })

            local servers = {
                pyright = {},
                vtsls = {},
                eslint = {},
                clangd = {},
                rust_analyzer = {},
                gopls = {},
            }

            for server, opts in pairs(servers) do
                opts.capabilities = capabilities
                opts.on_attach = on_attach
                lspconfig[server].setup(opts)
            end
        end,
    },
}

