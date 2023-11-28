

-- Define the function in the global scope
function _G.open_terminal(height)
    -- Open a terminal in a horizontal split
    vim.cmd('botright split | terminal')
    -- Resize the split to the specified height
    vim.cmd('resize ' .. height)
end

-- Map the function to <Leader>t
vim.api.nvim_set_keymap('n', '<Leader>t', ':lua open_terminal(10)<CR>', { noremap = true, silent = true })


function _G.run_current_file()
  local filetype = vim.bo.filetype
  local run_cmd = ''

  if filetype == 'python' then
    run_cmd = 'python ' .. vim.fn.expand('%')
  elseif filetype == 'javascript' then
    run_cmd = 'node ' .. vim.fn.expand('%')
    -- Add more conditions for other file types as needed
  end

  if run_cmd ~= '' then
    open_terminal(10)
    vim.cmd('term ' .. run_cmd)
  end
end
vim.api.nvim_set_keymap('n', '<Leader>r', '<cmd>lua run_current_file()<CR>', { noremap = true, silent = true })


-- escape terminal insert mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })


