return {
    -- Core completion plugins
    { 'hrsh7th/nvim-cmp',   -- Main completion plugin
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',  -- LSP completion
            'hrsh7th/cmp-buffer',    -- Buffer completion
            'hrsh7th/cmp-path',      -- File path completion
            'hrsh7th/cmp-vsnip',     -- Snippet completion
            'hrsh7th/vim-vsnip',     -- Snippet engine
            'zbirenbaum/copilot-cmp' -- GitHub Copilot integration
        },
        config = function()
            local cmp = require('cmp')

            local function feedkey(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body) -- For vsnip users
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn["vsnip#expandable"]() == 1 then
                            feedkey("<Plug>(vsnip-expand-or-jump)", "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            feedkey("<Plug>(vsnip-jump-prev)", "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'copilot' },
                    { name = 'vsnip' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        -- Customize the appearance of completion items
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            copilot = "[Copilot]",
                            vsnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                experimental = {
                    ghost_text = true, -- Show ghost text for Copilot suggestions
                },
            })

            -- Setup for specific filetypes if needed
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'cmp_git' }, -- git completions
                }, {
                    { name = 'buffer' },
                })
            })
        end,
    },
    { 'github/copilot.vim' } -- GitHub Copilot integration
}
