return {
  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Install languages
        ensure_installed = {
          "lua",                      -- Lua
          "vim",                      -- Vimscript
          "vimdoc",                   -- vimdoc
          "query",
          "bash",                     -- Bash
          "python",                   -- Python
          "javascript",               -- JavaScript
          "typescript",               -- TypeScript
          "tsx",                      -- TSX
          "c",                        -- C
          "cpp",                      -- C++
          "go",                       -- Go
          "html",                     -- HTML
          "css",                      -- CSS
          "json",                     -- JSON
          "markdown",                 -- Markdown
          "rust",                     -- Rust
        },
        sync_install = false,         -- Install parsers synchronously (only applied to `ensure_installed`)
        auto_install = true,          -- Automatically install missing parsers when entering buffer
        ignore_install = {},          -- List of parsers to ignore installing
        modules = {},                 -- List of modules (required field)

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        indent = { enable = true },
      })
    end,
  },
  -- Autotag as separate plugin (fixes deprecation warning)
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      enable_close = true,                -- Auto close tags
      enable_rename = true,               -- Auto rename pairs of tags
      enable_close_on_slash = false       -- Auto close on trailing </
    },
  },
}
