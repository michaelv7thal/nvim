
-- Terminal settings

function _G.open_terminal()
  vim.cmd('botright split | terminal')
end
vim.api.nvim_set_keymap('n', '<Leader>t', '<cmd>lua open_terminal()<CR>', { noremap = true, silent = true })


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
    open_terminal()
    vim.cmd('term ' .. run_cmd)
  end
end
vim.api.nvim_set_keymap('n', '<Leader>r', '<cmd>lua run_current_file()<CR>', { noremap = true, silent = true })


-- escape terminal insert mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
