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
                    'ts_ls',         -- JS/TS
                    'omnisharp',        -- C#
                    'rust_analyzer',    -- Rust
                    'clangd',           -- C/C++
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

            -- Function to determine the Python environment
            local function get_python_environment()
                -- 1. Check for Poetry environment
                local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info --path 2>/dev/null"))
                if vim.v.shell_error == 0 and poetry_venv ~= "" then
                    return poetry_venv .. "/bin/python"
                end

                -- 2. Check for Conda environment
                local conda_prefix = os.getenv("CONDA_PREFIX")
                if conda_prefix and conda_prefix ~= "" then
                    return conda_prefix .. "/bin/python"
                end

                -- 3. Default to system Python
                return vim.fn.exepath("python3") or vim.fn.exepath("python")
            end

            -- Automatically configure LSP servers
            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    local opts = {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    }

                    -- Special configuration for Python (Pyright)
                    if server_name == "pyright" then
                        local python_path = get_python_environment()
                        opts.settings = {
                            python = {
                                pythonPath = python_path,
                            },
                        }
                    end

                    lspconfig[server_name].setup(opts)
                end,
            })
        end
    }
}
