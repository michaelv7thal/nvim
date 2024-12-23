return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      -- Set highlights to blend with Rose Pine theme
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ccfd8", bg = "NONE" })      -- Light cyan for additions
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ebbcba", bg = "NONE" })   -- Soft peach for changes
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#eb6f92", bg = "NONE" })   -- Rose red for deletions
      vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#eb6f92", bg = "NONE" }) -- Same as deletions
      vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#f6c177", bg = "NONE" }) -- Muted gold for mixed changes

      -- Setup gitsigns
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true, -- Inline blame annotations
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Define custom keymaps
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
          map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function() gs.blame_line { full = true } end)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function() gs.diffthis("~") end)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
  -- Add vim-fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gcommit", "Gpush", "Gpull", "Gdiffsplit" }, -- Lazy load on Git commands
    config = function()
      -- Optional: Add custom key mappings or configurations for fugitive
      vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
      vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff" })
      vim.keymap.set("n", "<leader>gc", ":Gcommit<CR>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gp", ":Gpush<CR>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gl", ":Gpull<CR>", { desc = "Git pull" })
    end,
  },
}
