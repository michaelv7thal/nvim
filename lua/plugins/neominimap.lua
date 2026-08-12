-- Code minimap rendered with Braille characters. Picks up treesitter (see
-- lua/plugins/treesitter.lua) for syntax colours, gitsigns (lua/plugins/git.lua)
-- for the diff column and LSP diagnostics automatically -- no extra wiring, the
-- integrations activate when those plugins are present.
--
-- `lazy = false` is deliberate: the plugin hooks buffer/window events at startup
-- to know which windows need a minimap, so deferring it until first keypress
-- would leave already-open buffers without one.
return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,
  init = function()
    -- Upstream also recommends `vim.opt.wrap = false` here so long lines never
    -- run underneath the floating minimap. That is left alone on purpose:
    -- lua/config/settings.lua sets `wrap = true` and is required *after*
    -- lazy.setup(), so it would win anyway. sidescrolloff likewise only takes
    -- effect while wrap is off -- it is set so the recommendation holds if wrap
    -- is ever turned off. If the overlay becomes annoying, switch
    -- `layout` to "split" below: that reserves a real 20-column window instead
    -- of floating over the buffer's right edge.
    vim.opt.sidescrolloff = 36
    vim.g.neominimap = {
      auto_enable = true,
      layout = "float",
      float = {
        minimap_width = 20,
        window_border = "single",
      },
      split = {
        minimap_width = 20,
        direction = "right",
      },
      -- Cursor in the minimap follows the cursor in the source window.
      sync_cursor = true,
    }
  end,
  keys = {
    -- <leader>n is already the prefix for <leader>nh (:nohl) in
    -- lua/config/keymaps.lua; these extend it rather than collide with it.
    { "<leader>nm",  "<cmd>Neominimap Toggle<cr>",     desc = "Minimap: toggle globally" },
    { "<leader>no",  "<cmd>Neominimap Enable<cr>",     desc = "Minimap: enable globally" },
    { "<leader>nc",  "<cmd>Neominimap Disable<cr>",    desc = "Minimap: disable globally" },
    { "<leader>nr",  "<cmd>Neominimap Refresh<cr>",    desc = "Minimap: refresh" },
    { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>",  desc = "Minimap: toggle for buffer" },
    { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>",  desc = "Minimap: toggle for window" },
    { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>",  desc = "Minimap: toggle for tab" },
    -- Focus moves the cursor into the minimap so it can be scrolled directly;
    -- ToggleFocus is the one to reach for, the explicit pair is there for maps.
    { "<leader>ns",  "<cmd>Neominimap ToggleFocus<cr>", desc = "Minimap: toggle focus" },
    { "<leader>nf",  "<cmd>Neominimap Focus<cr>",       desc = "Minimap: focus" },
    { "<leader>nu",  "<cmd>Neominimap Unfocus<cr>",     desc = "Minimap: unfocus" },
  },
}
