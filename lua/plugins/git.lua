return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      -- Setup gitsigns first
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

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
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })

      -- Dynamically set highlights *after* colorscheme is applied
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("GitSignsColors", { clear = true }),
        callback = function()
          -- Use highlight groups from current colorscheme if available, or set fallbacks
          vim.api.nvim_set_hl(0, "GitSignsAdd",         { link = "DiffAdd" })
          vim.api.nvim_set_hl(0, "GitSignsChange",      { link = "DiffChange" })
          vim.api.nvim_set_hl(0, "GitSignsDelete",      { link = "DiffDelete" })
          vim.api.nvim_set_hl(0, "GitSignsTopdelete",   { link = "DiffDelete" })
          vim.api.nvim_set_hl(0, "GitSignsChangedelete",{ link = "DiffChange" })
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
