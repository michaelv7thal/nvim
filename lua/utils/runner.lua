-- Best practice: File runner that executes files in terminal splits

local M = {}

-- File type to command mapping
local runners = {
    python = "python3 %s",
    lua = "lua %s",
    javascript = "node %s",
    typescript = "ts-node %s",
    rust = "cargo run",
    sh = "bash %s",
    bash = "bash %s",
    zsh = "zsh %s",
    r = "Rscript %s",
    go = "go run %s",
    c = "gcc %s -o /tmp/a.out && /tmp/a.out",
    cpp = "g++ %s -o /tmp/a.out && /tmp/a.out",
}

-- Find an existing terminal buffer
local function find_terminal_buffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
            if buf_type == "terminal" then
                -- Check if terminal buffer is visible in any window
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_get_buf(win) == buf then
                        return win, buf
                    end
                end
            end
        end
    end
    return nil, nil
end

-- Create a new terminal in horizontal split
local function create_terminal()
    vim.cmd("split")
    local win = vim.api.nvim_get_current_win()
    vim.cmd("term")
    local buf = vim.api.nvim_get_current_buf()
    
    -- Resize terminal to reasonable height
    vim.api.nvim_win_set_height(win, 12)
    
    return win, buf
end

-- Send command to terminal
local function send_to_terminal(buf, command)
    -- Get the terminal's job id
    local job_id = vim.api.nvim_buf_get_var(buf, "terminal_job_id")
    
    if job_id then
        -- Send the command
        vim.api.nvim_chan_send(job_id, command .. "\n")
    end
end

-- Main function to run the current file
function M.run_file()
    local filetype = vim.bo.filetype
    local filepath = vim.fn.expand("%:p")
    local filename = vim.fn.expand("%:t")
    
    -- Check if file is saved
    if vim.bo.modified then
        vim.notify("File has unsaved changes. Save first!", vim.log.levels.WARN)
        return
    end
    
    -- Check if empty file
    if filepath == "" then
        vim.notify("No file to run!", vim.log.levels.ERROR)
        return
    end
    
    -- Get the command for this filetype
    local cmd_template = runners[filetype]
    if not cmd_template then
        vim.notify("No runner configured for filetype: " .. filetype, vim.log.levels.ERROR)
        return
    end
    
    -- Format the command
    local command
    if cmd_template:find("%%s") then
        command = string.format(cmd_template, vim.fn.shellescape(filepath))
    else
        command = cmd_template  -- For commands like 'cargo run' that don't need filepath
    end
    
    -- Find or create terminal
    local term_win, term_buf = find_terminal_buffer()
    local current_win = vim.api.nvim_get_current_win()
    
    if not term_win then
        term_win, term_buf = create_terminal()
        -- Wait a moment for terminal to initialize
        vim.defer_fn(function()
            send_to_terminal(term_buf, command)
            -- Return focus to original window
            vim.api.nvim_set_current_win(current_win)
        end, 100)
    else
        send_to_terminal(term_buf, command)
        -- Brief flash to terminal and back to show execution
        vim.api.nvim_set_current_win(term_win)
        vim.defer_fn(function()
            vim.api.nvim_set_current_win(current_win)
        end, 50)
    end
    
    vim.notify("Running: " .. command, vim.log.levels.INFO)
end

-- Function to add custom runner
function M.add_runner(filetype, command)
    runners[filetype] = command
end

-- Function to get current runners
function M.list_runners()
    return runners
end

return M
