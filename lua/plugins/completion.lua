-- Enable Copilot for all filetypes
vim.g.copilot_filetypes = {
    ["*"] = true,
}

-- Disable Copilot's default <Tab> keymap (we'll handle it ourselves)
vim.g.copilot_no_tab_map = true

-- Don't show Copilot suggestions when completion menu is visible
vim.g.copilot_assume_mapped = true


return {
    -- GitHub Copilot core plugin (for inline ghost text)
    {
        'github/copilot.vim',
        lazy = false, -- always load
    },

    -- Completion core
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',   -- LSP completion
            'hrsh7th/cmp-buffer',     -- Buffer completion
            'hrsh7th/cmp-path',       -- File path completion
            'hrsh7th/cmp-vsnip',      -- Snippet completion
            'hrsh7th/vim-vsnip',      -- Snippet engine
        },
        config = function()
            local cmp = require('cmp')

            local function feedkey(key, mode)
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes(key, true, true, true),
                    mode,
                    true
                )
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                completion = {
                    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),

                    -- Enter: Accept selected completion item, or just insert newline if nothing selected
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

                    -- Tab: Accept Copilot ghost text, or navigate completion menu, or expand snippet
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        -- First priority: Navigate completion menu if visible
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            -- Try to accept Copilot suggestion
                            local ok, result = pcall(vim.fn['copilot#Accept'], "")
                            if ok and result ~= "" then
                                -- Copilot accepted, keys are in result
                                vim.api.nvim_feedkeys(result, 'n', false)
                            elseif vim.fn["vsnip#expandable"]() == 1 then
                                -- Expand snippet
                                feedkey("<Plug>(vsnip-expand-or-jump)", "")
                            else
                                -- Default tab behavior
                                fallback()
                            end
                        end
                    end, { "i", "s" }),

                    -- Shift+Tab: Navigate backwards in completion menu or snippet
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            feedkey("<Plug>(vsnip-jump-prev)", "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Ctrl+n/Ctrl+p: Navigate completion menu (alternative to Tab/S-Tab)
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', priority = 100 },  -- Highest priority for LSP completions
                    { name = 'vsnip', priority = 50 },
                }, {
                    { name = 'buffer', priority = 10 },
                    { name = 'path', priority = 20 },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        local menu_map = {
                            nvim_lsp = "[LSP]",
                            vsnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        }
                        vim_item.menu = menu_map[entry.source.name] or ("[" .. entry.source.name .. "]")
                        return vim_item
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                -- Disable nvim-cmp's ghost_text to avoid conflict with Copilot
                experimental = {
                    ghost_text = false,
                },
            })

            -- Git commit completion
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'buffer' },
                }),
            })
        end,
    },
}

