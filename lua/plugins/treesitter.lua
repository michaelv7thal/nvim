-- nvim-treesitter MAIN branch.
--
-- The legacy `master` branch caps out at Neovim 0.11 ("0.12 is not supported",
-- per its README) and is frozen, so on Neovim 0.12+ its highlighter crashes
-- (`attempt to call method 'range' (a nil value)`). The `main` branch is the
-- rewrite that supports 0.12; its API is different:
--   * no `require("nvim-treesitter.configs").setup{...}` modules table
--   * highlight  -> per-buffer `vim.treesitter.start()` (FileType autocmd)
--   * indent     -> experimental `indentexpr()`
--   * install    -> `require("nvim-treesitter").install{...}` (async)
--   * ensure/auto_install/incremental_selection are gone -> reimplemented below
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    -- Load at startup so the FileType autocmd below is registered before the
    -- first buffer's FileType fires (otherwise the first file won't highlight).
    lazy = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      local ts = require("nvim-treesitter")

      -- Parsers + queries install under stdpath('data')/site by default, which
      -- the plugin prepends to runtimepath.
      ts.setup()

      -- Parsers to keep installed (was master's `ensure_installed`).
      local ensure = {
        "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "tsx",
        "python", "rust", "go",
        "html", "css", "json",
        "markdown", "markdown_inline",
        "bash", "c", "cpp",
        "terraform", "hcl",
      }

      -- Neovim guesses `.tf` by content and falls back to TinyFugue (`tf`) for
      -- empty files or ones starting with `//` / `/*` comments; always use
      -- terraform. `.tfvars` already maps to `terraform-vars` (terraform parser).
      vim.filetype.add({
        extension = { tf = "terraform" },
      })

      -- Install only the missing ones (install is async, non-blocking).
      local have = {}
      for _, l in ipairs(ts.get_installed("parsers")) do
        have[l] = true
      end
      local missing = vim.tbl_filter(function(l) return not have[l] end, ensure)
      if #missing > 0 then
        pcall(ts.install, missing)
      end

      -- Enable highlight + indent per buffer; replaces master's
      -- highlight.enable / indent.enable, plus `auto_install` (fetch a missing
      -- parser on the fly, then start highlighting once it lands).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ts_start", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then return end

          local function start()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            pcall(vim.treesitter.start, buf, lang)
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          if vim.treesitter.language.add(lang) then
            start()
          elseif vim.tbl_contains(ts.get_available(), lang) then
            -- auto_install: parser exists upstream but isn't installed yet.
            pcall(function()
              ts.install({ lang }):await(vim.schedule_wrap(start))
            end)
          end
        end,
      })

      ----------------------------------------------------------------------
      -- Incremental selection (master's `incremental_selection` is gone on
      -- `main`). Minimal reimplementation: <C-space> starts/expands to the
      -- enclosing node, <BS> shrinks back. Per-buffer range stack.
      ----------------------------------------------------------------------
      local stacks = {} -- buf -> { {srow,scol,erow,ecol}, ... }

      local function select_range(range)
        local sr, sc, er, ec = range[1], range[2], range[3], range[4]
        -- node ranges are 0-indexed, end-exclusive; clamp end to a real char.
        if ec == 0 and er > sr then
          er = er - 1
          ec = #vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1]
        end
        if ec > 0 then ec = ec - 1 end
        vim.cmd("normal! \27") -- leave any visual mode first
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec, 0) })
      end

      -- Smallest ancestor whose range is strictly larger than `cur`.
      local function bigger_ancestor(node, cur)
        local n = node
        while n do
          local sr, sc, er, ec = n:range()
          if sr < cur[1] or (sr == cur[1] and sc < cur[2])
            or er > cur[3] or (er == cur[3] and ec > cur[4]) then
            return { sr, sc, er, ec }
          end
          n = n:parent()
        end
      end

      local function init_or_expand()
        local buf = vim.api.nvim_get_current_buf()
        local node = vim.treesitter.get_node()
        if not node then return end
        local stack = stacks[buf]
        local range
        if stack and #stack > 0 then
          range = bigger_ancestor(node, stack[#stack])
          if not range then return end
        else
          range = { node:range() }
          stack = {}
        end
        select_range(range) -- fires ModeChanged, which clears stacks[buf]
        table.insert(stack, range)
        stacks[buf] = stack -- restore after the clear
      end

      local function shrink()
        local buf = vim.api.nvim_get_current_buf()
        local stack = stacks[buf]
        if not stack or #stack <= 1 then return end
        table.remove(stack)
        select_range(stack[#stack])
        stacks[buf] = stack
      end

      -- Forget the selection once the user returns to normal mode.
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "[vV\22]*:n",
        callback = function()
          stacks[vim.api.nvim_get_current_buf()] = nil
        end,
      })
      vim.api.nvim_create_autocmd("BufWipeout", {
        callback = function(a) stacks[a.buf] = nil end,
      })

      local function guard(fn)
        return function() pcall(fn) end
      end
      vim.keymap.set("n", "<C-space>", guard(init_or_expand),
        { silent = true, desc = "TS: start/expand selection" })
      vim.keymap.set("x", "<C-space>", guard(init_or_expand),
        { silent = true, desc = "TS: expand selection" })
      vim.keymap.set("x", "<BS>", guard(shrink),
        { silent = true, desc = "TS: shrink selection" })
    end,
  },
}
