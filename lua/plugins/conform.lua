return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
        -- latexindent is slow to start (Perl), so give .tex a longer timeout
        -- while keeping everything else snappy at 500ms.
        format_on_save = function(bufnr)
            local timeout = vim.bo[bufnr].filetype == "tex" and 3000 or 500
            return { timeout_ms = timeout, lsp_fallback = true }
        end,
        formatters = {
            -- One sentence per line for LaTeX prose. -m turns on the
            -- modifyLineBreaks rules in the project's latexindent.yaml.
            -- require_cwd + cwd marker => only runs in a project that has a
            -- latexindent.yaml, so it stays inert in every other repo.
            -- NB: do NOT add -s (silent). In stdin mode (latexindent 4.0) -s
            -- suppresses the formatted result on STDOUT, so conform sees empty
            -- output and skips the write — i.e. nothing happens on :w. The log
            -- already goes to /dev/null via -g, and diagnostics go to STDERR.
            latexindent = {
                command = "latexindent",
                args = { "-m", "-g", "/dev/null", "-l", "latexindent.yaml", "-" },
                stdin = true,
                require_cwd = true,
                cwd = function(_, ctx)
                    return vim.fs.root(ctx.dirname, { "latexindent.yaml" })
                end,
            },
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
            html = { "prettier" },
            css = { "prettier"},
            tex = { "latexindent" },
        },
    },
}

