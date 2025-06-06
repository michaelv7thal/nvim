return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters_by_ft = {
            python = { "black" },
            lua = { "stylua" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            rust = { "rustfmt" },
            go = { "gofmt" },
            cpp = { "clang-format" },
            c = { "clang-format" },
        },
    },
}

