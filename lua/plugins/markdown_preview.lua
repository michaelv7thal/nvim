return {
  {
    "iamcco/markdown-preview.nvim",
    -- Download the prebuilt standalone binary; avoids needing yarn/node deps.
    build = function() vim.fn["mkdp#util#install"]() end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown", -- lazy-load on markdown filetypes
    init = function()
      -- Set options before the plugin loads
      vim.g.mkdp_auto_start = 0          -- don't auto-open the browser; preview only via :MarkdownPreview
      vim.g.mkdp_auto_close = 1          -- auto close preview when leaving markdown
      -- Devcontainer: the server must bind 0.0.0.0 (NOT the default 127.0.0.1)
      -- so the published Docker port can reach it. mkdp_host is NOT read by the
      -- plugin; binding is controlled solely by mkdp_open_to_the_world.
      vim.g.mkdp_open_to_the_world = 1
      -- ...but the URL should point at the host's published loopback mapping,
      -- not the container's LAN IP (which open_to_the_world would otherwise use).
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "4243"           -- must match the "ports:" mapping in docker-compose.local.yml

      -- Devcontainer: there is NO browser inside the container, so the default
      -- open-browser step fails. Ship the URL to the HOST via the $BROWSER
      -- bridge (open-on-host -> socat -> host xdg-open; see docker-compose.local.yml),
      -- and also echo it + yank to + as a fallback. The host reaches the
      -- server at http://127.0.0.1:4243 via the published port.
      vim.g.mkdp_browserfunc = "MkdpOpenOnHost"
      vim.cmd([[
        function! MkdpOpenOnHost(url) abort
          let @+ = a:url
          echom 'Markdown preview (open on host): ' . a:url
          let l:browser = $BROWSER
          if !empty(l:browser) && executable(l:browser)
            call jobstart([l:browser, a:url])
          endif
        endfunction
      ]])
    end,
  },
}
