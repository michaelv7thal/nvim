return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",  -- required build step for the plugin
    ft = "markdown",                    -- lazy-load on markdown filetypes
    init = function()
      -- Set options before the plugin loads
      vim.g.mkdp_auto_start = 1      -- auto start preview when opening markdown
      vim.g.mkdp_auto_close = 1      -- auto close preview when leaving markdown
      vim.g.mkdp_host = "172.31.112.1"    -- bind to localhost to restrict access
      vim.g.mkdp_port = "8080"         -- you can change this if needed
    end,
  },
}
