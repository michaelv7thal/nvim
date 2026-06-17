return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
  -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
  -- spec defers loading until a <leader>a* mapping is pressed and the commands
  -- would not exist yet.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>a",  nil,                   desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    {
      "<leader>an",
      -- Recreate the ONE interactive Claude conversation (the chat you type
      -- into), so there is only ever a single live dev session.
      --
      -- `ClaudeCodeStart`/`Stop` manage only the background WebSocket server
      -- (the "port"); they do NOT touch the conversation, which runs as a
      -- `claude` process inside a terminal owned by the terminal provider. So a
      -- true restart means force-wiping that terminal buffer -- which kills the
      -- process for both the snacks and native providers (the native provider's
      -- close only hides the buffer and would orphan the process) -- and then
      -- opening a single fresh session. `auto_start` keeps the server alive.
      function()
        local term_ok, terminal = pcall(require, "claudecode.terminal")
        if term_ok then
          local bufnr = terminal.get_active_terminal_bufnr()
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
          end
        end

        -- Ensure the integration server is up (start it only when it isn't, to
        -- avoid a spurious "already running" warning), then open the fresh
        -- conversation.
        local cc_ok, claudecode = pcall(require, "claudecode")
        if cc_ok and not (claudecode.state and claudecode.state.server) then
          claudecode.start(false)
        end

        vim.cmd("ClaudeCodeOpen")
      end,
      desc = "New Claude session",
    },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
  },
}
