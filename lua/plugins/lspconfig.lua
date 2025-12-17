return {
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
            local mason_lspconfig = require("mason-lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Best practice: Enhanced capabilities with additional features
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = { "documentation", "detail", "additionalTextEdits" },
            }

            local on_attach = function(client, bufnr)
                -- Best practice: Disable formatting for certain LSPs if using conform.nvim
                if client.name == "tsserver" or client.name == "vtsls" then
                    client.server_capabilities.documentFormattingProvider = false
                end

                local opts = { buffer = bufnr, silent = true, noremap = true }
                local keymap = vim.keymap.set

                -- Navigation keymaps
                keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                keymap("n", "gi", vim.lsp.buf.implementation,
                    vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
                keymap("n", "gt", vim.lsp.buf.type_definition,
                    vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

                -- Hover and signature help
                keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
                keymap("n", "<C-k>", vim.lsp.buf.signature_help,
                    vim.tbl_extend("force", opts, { desc = "Signature help" }))
                keymap("i", "<C-k>", vim.lsp.buf.signature_help,
                    vim.tbl_extend("force", opts, { desc = "Signature help (insert mode)" }))

                -- Code actions and refactoring
                keymap("n", "<leader>ca", vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Code action" }))
                keymap("v", "<leader>ca", vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Code action (visual)" }))
                keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

                -- Formatting
                keymap("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))

                -- Diagnostics
                keymap("n", "[d", vim.diagnostic.goto_prev,
                    vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                keymap("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                keymap("n", "<leader>d", vim.diagnostic.open_float,
                    vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
                keymap("n", "<leader>q", vim.diagnostic.setloclist,
                    vim.tbl_extend("force", opts, { desc = "Diagnostic list" }))

                -- Workspace management
                keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
                    vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
                keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
                    vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
                keymap("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

                -- Best practice: Highlight symbol under cursor
                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        group = "lsp_document_highlight",
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        group = "lsp_document_highlight",
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end

            -- Best practice: Configure diagnostic display
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = "if_many",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            -- Best practice: Customize LSP floating window borders
            local handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }

            -- Best practice: Setup diagnostic signs
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
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
                    "lua_ls", -- Best practice: Add lua_ls for Neovim config editing
                },
                automatic_installation = true,
            })

            -- CRITICAL: Actually configure the LSP servers
            -- Using modern vim.lsp.config API (Neovim 0.11+)

            -- Define server-specific configurations
            local server_configs = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = {
                                globals = { "vim" }, -- Recognize 'vim' global
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                    },
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
            }

            -- Setup all installed servers using modern API
            local function setup_servers()
                local installed = mason_lspconfig.get_installed_servers()
                for _, server_name in ipairs(installed) do
                    -- Merge default config with server-specific config
                    local config = vim.tbl_deep_extend("force", {
                        capabilities = capabilities,
                        handlers = handlers,
                    }, server_configs[server_name] or {})

                    -- Use modern vim.lsp.config API
                    vim.lsp.config(server_name, config)

                    -- Enable the server for appropriate filetypes
                    vim.lsp.enable(server_name)
                end
            end

            -- Setup on_attach via LspAttach autocmd (modern approach)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then
                        on_attach(client, args.buf)
                    end
                end,
            })

            -- Setup servers now
            setup_servers()

            -- Re-setup when new servers are installed
            vim.api.nvim_create_autocmd("User", {
                pattern = "MasonToolsUpdateCompleted",
                callback = setup_servers,
            })
        end,
    },
}
