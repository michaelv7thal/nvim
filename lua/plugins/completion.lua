-- Enable Copilot for all filetypes
vim.g.copilot_filetypes = {
    ["*"] = true,
}
-- Disable Copilot's default <Tab> keymap to avoid conflict with nvim-cmp
vim.g.copilot_no_tab_map = true
return {
    -- GitHub Copilot core plugin (must load before copilot-cmp)
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
            {
                'zbirenbaum/copilot-cmp',
                dependencies = { 'github/copilot.vim' },
                config = function()
                    require("copilot_cmp").setup()
                end,
            },
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
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn["vsnip#expandable"]() == 1 then
                            feedkey("<Plug>(vsnip-expand-or-jump)", "")
                        else
                            -- Accept Copilot suggestion if available
                            local copilot_keys = vim.fn['copilot#Accept']()
                            if copilot_keys ~= '' then
                                vim.api.nvim_feedkeys(copilot_keys, 'i', true)
                            else
                                fallback()
                            end
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
                    ghost_text = true, -- Copilot ghost text enabled
                },
            })
            -- Git commit completion (optional: requires 'petertriho/cmp-git')
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'cmp_git' }, -- only works if cmp-git is installed
                }, {
                    { name = 'buffer' },
                }),
            })
        end,
    },
}
