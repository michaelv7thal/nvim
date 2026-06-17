return {
  {
    "iamcco/markdown-preview.nvim",
    -- Download the prebuilt standalone binary; avoids needing yarn/node deps.
    build = function() vim.fn["mkdp#util#install"]() end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown", -- lazy-load on markdown filetypes
    init = function()
      -- Set options before the plugin loads
      vim.g.mkdp_auto_start = 1     -- auto start preview when opening markdown
      vim.g.mkdp_auto_close = 1     -- auto close preview when leaving markdown
      vim.g.mkdp_host = "127.0.0.1" -- bind to localhost to restrict access
      vim.g.mkdp_port = "4243"      -- you can change this if needed
    end,
  },
}
