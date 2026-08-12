-- Countdown for the active pomo.nvim timer, e.g. "󰄉 Work: 24:59".
--
-- Guarded on `package.loaded` rather than `pcall(require, "pomo")`: under
-- lazy.nvim a require would *load* pomo.nvim on the first statusline redraw,
-- undoing its lazy spec. While no timer is running this returns "" and the
-- component collapses. Timers are keyed by whichever finishes first, and
-- `tostring` already renders name, remaining time and "(paused)" -- only its
-- "#<id>," prefix is dropped, since the id isn't useful in the statusline.
local function pomo_timer()
    if not package.loaded["pomo"] then
        return ""
    end
    local timer = require("pomo").get_first_to_finish()
    if timer == nil then
        return ""
    end
    local text = tostring(timer):gsub("^#%d+[,:]%s*", "")
    return "󰄉 " .. text
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { { "filename", path = 1} },
                lualine_x = { pomo_timer, "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
