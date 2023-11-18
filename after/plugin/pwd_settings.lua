
function SetWorkingDirectory()
    -- Get the full path of the current file
    local filepath = vim.fn.expand('%:p')
    if filepath == '' then
        return
    end

    -- Get the directory of the current file
    local filedir = vim.fn.expand('%:p:h')

    -- Check if the file is in a Git repository
    local gitdir = vim.fn.systemlist('git -C ' .. filedir .. ' rev-parse --show-toplevel')[1]

    -- If in a Git repository, change pwd to the Git root, else to the file's directory
    if vim.v.shell_error == 0 then
        vim.api.nvim_set_current_dir(gitdir)
    else
        vim.api.nvim_set_current_dir(filedir)
    end
end


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    pattern = "*",
    callback = SetWorkingDirectory
})
