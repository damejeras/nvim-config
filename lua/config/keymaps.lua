-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- Shift blocks in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Shift block left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Shift block right' })

-- Buffer keymaps
vim.keymap.set('n', '<leader>\\', '<cmd>BufferPick<CR>', { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader><enter>', '<cmd>BufferPin<CR>', { desc = 'Pin buffer' })
vim.keymap.set('n', '<leader><space>', '<cmd>BufferNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader><backspace>', '<cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader><delete>', '<cmd>BufferCloseAllButPinned<CR>', { desc = 'Close unpined buffers' })

-- Close pane
vim.keymap.set('n', '<leader>x', function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins == 1 then
    vim.cmd('quit')
  else
    vim.cmd('close')
  end
end, { noremap = true, silent = true })
