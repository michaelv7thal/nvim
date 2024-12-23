return {
    -- Mason (LSP installer)
    {'williamboman/mason.nvim', config = true},
    {'williamboman/mason-lspconfig.nvim', config = true},

    -- LSP Config
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp', -- LSP completion source
        },
        config = function()
            -- Setup Mason
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                'pyright',          -- Python
                'tsserver',         -- JS/TS
                'omnisharp',        -- C#
                'rust_analyzer',    -- Rust
                'gopls',             -- Go
                'clangd',            -- C/C++
                }
            })
            
            -- LSP Keybindings and Capabilities
            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local on_attach = function(client, bufnr)
                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({async = true}) end, bufopts)
            end

            -- Automatically configure LSP servers
            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            })
        end
    }
}
