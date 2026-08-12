-- Pomodoro timers. The live countdown is rendered in lualine (see
-- lua/plugins/lualine.lua), so the notifiers here only announce start/finish.
return {
  "epwalsh/pomo.nvim",
  version = "*",
  cmd = {
    "TimerStart",
    "TimerRepeat",
    "TimerSession",
    "TimerStop",
    "TimerPause",
    "TimerResume",
    "TimerHide",
    "TimerShow",
  },
  keys = {
    { "<leader>p",  nil,                              desc = "Pomodoro" },
    { "<leader>pp", "<cmd>TimerSession pomodoro<cr>", desc = "Start pomodoro session (4x 25m/5m)" },
    { "<leader>pw", "<cmd>TimerStart 25m Work<cr>",   desc = "Start 25m work timer" },
    { "<leader>pb", "<cmd>TimerStart 5m Break<cr>",   desc = "Start 5m break timer" },
    { "<leader>pq", "<cmd>TimerStop -1<cr>",          desc = "Stop all timers" },
    {
      -- One key for pause/resume: pomo only ships separate :TimerPause /
      -- :TimerResume, so branch on the timer's own `paused` flag.
      "<leader>pt",
      function()
        local pomo = require("pomo")
        local timer = pomo.get_first_to_finish()
        if timer == nil then
          vim.notify("No active pomodoro timer", vim.log.levels.WARN)
          return
        end
        if timer.paused then
          pomo.resume_timer(timer)
        else
          pomo.pause_timer(timer)
        end
      end,
      desc = "Toggle pause on current timer",
    },
  },
  opts = {
    update_interval = 1000, -- also the lualine refresh cadence for the countdown
    -- nvim-notify isn't installed, so the Default notifier falls back to
    -- `vim.notify`. Hence sticky = false: a sticky notifier re-notifies on every
    -- tick, which spams the message area once a second when there is no
    -- notification UI to update in place. Start/done messages still come through.
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = false,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
      -- Desktop notification when a timer finishes (notify-send on Linux), so a
      -- finished work block reaches you even when Neovim isn't focused.
      { name = "System" },
    },
    sessions = {
      -- 25m work / 5m break, four rounds. `:TimerSession pomodoro` walks the
      -- list, starting the next timer as each one finishes.
      pomodoro = {
        { name = "Work",  duration = "25m" },
        { name = "Break", duration = "5m" },
        { name = "Work",  duration = "25m" },
        { name = "Break", duration = "5m" },
        { name = "Work",  duration = "25m" },
        { name = "Break", duration = "5m" },
        { name = "Work",  duration = "25m" },
        { name = "Break", duration = "5m" },
      },
    },
  },
}
