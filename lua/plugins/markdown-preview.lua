
return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install", -- Automatically install dependencies
    ft = "markdown", -- Load plugin only for Markdown files
    config = function()
    -- Optionally, set key mappings or other settings
    vim.g.mkdp_auto_start = 1 -- Automatically start preview when opening a Markdown file
    vim.g.mkdp_auto_close = 1 -- Close preview when exiting the file
    vim.g.mkdp_refresh_slow = 0 -- Fast refresh for live updates
    vim.g.mkdp_browser = "" -- Use the default browser
    vim.g.mkdp_theme = "dark" -- Set theme to dark
  end,

}
