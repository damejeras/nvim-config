-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'v' }, '<leader>y', '"+y', { desc = 'Copy to clipboard' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- Shift blocks in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Shift block left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Shift block right' })

-- Buffer keymaps
vim.keymap.set('n', '<leader>\\', '<cmd>Telescope buffers<CR>', { desc = 'Pick buffer' })
-- vim.keymap.set('n', '<leader><enter>', '<cmd>BufferPin<CR>', { desc = 'Pin buffer' })
vim.keymap.set('n', '<leader><space>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader><backspace>', '<cmd>bprev<CR>', { desc = 'Previous buffer' })
-- vim.keymap.set('n', '<leader><delete>', '<cmd>BufferCloseAllButPinned<CR>', { desc = 'Close unpined buffers' })

-- Helper function to count windows in the same axis
local function count_windows_in_axis(vertical)
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local count = 0

  for _, win in ipairs(wins) do
    local pos1 = vim.api.nvim_win_get_position(current_win)
    local pos2 = vim.api.nvim_win_get_position(win)

    if vertical then
      -- For vertical splits, compare y positions
      if pos1[1] == pos2[1] then
        count = count + 1
      end
    else
      -- For horizontal splits, compare x positions
      if pos1[2] == pos2[2] then
        count = count + 1
      end
    end
  end

  return count
end

-- Global variable to track the state of the split width cycle
local width_state = 1 -- Start at 1/3 width

vim.keymap.set('n', '<C-h>', function()
  -- Check if there are vertical splits in the same row
  if count_windows_in_axis(true) <= 1 then return end

  local total_width = vim.o.columns
  local win_id = vim.api.nvim_get_current_win()
  local count = vim.v.count
  local current_width = vim.api.nvim_win_get_width(win_id)

  -- Rest of the width cycling logic remains the same
  if count > 0 then
    if count >= total_width then
      vim.api.nvim_win_set_width(win_id, total_width)
      width_state = (width_state % 4) + 1
    else
      vim.api.nvim_win_set_width(win_id, count)
    end
    return
  end

  local one_third = math.floor(total_width / 3)
  local one_half = math.floor(total_width / 2)
  local two_thirds = math.floor(2 * total_width / 3)

  local width_diff = {}
  width_diff[1] = math.abs(current_width - one_third)
  width_diff[2] = math.abs(current_width - one_half)
  width_diff[3] = math.abs(current_width - two_thirds)
  width_diff[4] = math.abs(current_width - total_width)

  local min_diff = width_diff[1]
  width_state = 1
  for i = 2, 4 do
    if width_diff[i] < min_diff then
      min_diff = width_diff[i]
      width_state = i
    end
  end

  width_state = (width_state % 4) + 1

  if width_state == 1 then
    vim.api.nvim_win_set_width(win_id, one_third)
  elseif width_state == 2 then
    vim.api.nvim_win_set_width(win_id, one_half)
  elseif width_state == 3 then
    vim.api.nvim_win_set_width(win_id, two_thirds)
  else
    vim.api.nvim_win_set_width(win_id, total_width)
  end
end, { noremap = true, silent = true })

local height_state = 1 -- Start at 1/4 height

vim.keymap.set('n', '<C-j>', function()
  -- Check if there are horizontal splits in the same column
  if count_windows_in_axis(false) <= 1 then return end

  local total_height = vim.o.lines - vim.o.cmdheight - 1
  local win_id = vim.api.nvim_get_current_win()
  local count = vim.v.count
  local current_height = vim.api.nvim_win_get_height(win_id)

  -- Rest of the height cycling logic remains the same
  if count > 0 then
    if count >= total_height then
      vim.api.nvim_win_set_height(win_id, total_height)
      height_state = (height_state % 5) + 1
    else
      vim.api.nvim_win_set_height(win_id, count)
    end
    return
  end

  local one_quarter = math.floor(total_height / 4)
  local one_third = math.floor(total_height / 3)
  local one_half = math.floor(total_height / 2)
  local two_thirds = math.floor(2 * total_height / 3)
  local four_fifths = math.floor(4 * total_height / 5)

  local height_diff = {}
  height_diff[1] = math.abs(current_height - one_quarter)
  height_diff[2] = math.abs(current_height - one_third)
  height_diff[3] = math.abs(current_height - one_half)
  height_diff[4] = math.abs(current_height - two_thirds)
  height_diff[5] = math.abs(current_height - four_fifths)

  local min_diff = height_diff[1]
  height_state = 1
  for i = 2, 5 do
    if height_diff[i] < min_diff then
      min_diff = height_diff[i]
      height_state = i
    end
  end

  height_state = (height_state % 5) + 1

  if height_state == 1 then
    vim.api.nvim_win_set_height(win_id, one_quarter)
  elseif height_state == 2 then
    vim.api.nvim_win_set_height(win_id, one_third)
  elseif height_state == 3 then
    vim.api.nvim_win_set_height(win_id, one_half)
  elseif height_state == 4 then
    vim.api.nvim_win_set_height(win_id, two_thirds)
  else
    vim.api.nvim_win_set_height(win_id, four_fifths)
  end
end, { noremap = true, silent = true })
