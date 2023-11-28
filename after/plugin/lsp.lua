require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "eslint",
        "tsserver",
        "lua_ls",
        "rust_analyzer",
        "pylsp",
    },
}

vim.diagnostic.config({
    virtual_text = false,
})

local lsp = require('lsp-zero')

lsp.preset('recommended')

-- Configure pylsp
lsp.configure('pylsp', {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'E501' }, -- Ignore E501 line too long
                    maxLineLength = 80   -- Or set a custom max line length
                }
            }
        }
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    lsp.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,

    },
})


lsp.setup_servers({ 'tsserver', 'rust_analyzer', 'pylsp' })

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()


cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<A-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ['<A-f>'] = cmp_action.luasnip_jump_forward(),
        ['<A-b>'] = cmp_action.luasnip_jump_backward(),

        -- Scroll up and down in the completion documentation
        ['<A-u>'] = cmp.mapping.scroll_docs(-4),
        ['<A-d>'] = cmp.mapping.scroll_docs(4),
    })
})




-- python black formatter


local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- Rust formatter
        null_ls.builtins.formatting.rustfmt,

        -- Python Black formatter
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length", "80", "--fast" },
        }),

        -- SQL formatter
        null_ls.builtins.formatting.sqlfmt,

    }
})




vim.cmd [[
    augroup FormatAutogroup
        autocmd!
        autocmd BufWritePre *.py lua vim.lsp.buf.format({ async = false })
        autocmd BufWritePre *.sql lua vim.lsp.buf.format({ async = false })
        autocmd BufWritePRe *.rs lua vim.lsp.buf.format({async = false})
    augroup END
]]
