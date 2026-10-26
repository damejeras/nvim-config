-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "v" }, "<RightMouse>", '"+y', { desc = "Copy to clipboard" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>k", function()
	vim.diagnostic.open_float({ focusable = true, scope = "cursor" })
end, { desc = "Open diagnostic float (focusable)" })

-- Shift blocks in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Shift block left" })
vim.keymap.set("v", ">", ">gv", { desc = "Shift block right" })

-- Buffer keymaps
vim.keymap.set("n", "<leader><enter>", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
vim.keymap.set("n", "<leader><space>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader><backspace>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>\\", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader><delete>", function()
	local groups = require("bufferline.groups")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and not groups._is_pinned({ id = buf }) then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end, { desc = "Close unpinned buffers" })

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

local function resize(vertical)
	if count_windows_in_axis(vertical) <= 1 then
		return
	end

	local total = vertical and vim.o.columns or (vim.o.lines - vim.o.cmdheight - 1)
	local get_size = vertical and vim.api.nvim_win_get_width or vim.api.nvim_win_get_height
	local set_size = vertical and vim.api.nvim_win_set_width or vim.api.nvim_win_set_height
	if vim.v.count > 0 then
		set_size(0, math.min(vim.v.count, total))
		return
	end

	local fractions = vertical and { 1 / 3, 1 / 2, 2 / 3, 1 } or { 1 / 4, 1 / 3, 1 / 2, 2 / 3, 4 / 5 }
	local current = get_size(0)
	local nearest, difference = 1, math.huge
	for i, fraction in ipairs(fractions) do
		local distance = math.abs(current - math.floor(total * fraction))
		if distance < difference then
			nearest, difference = i, distance
		end
	end
	set_size(0, math.floor(total * fractions[nearest % #fractions + 1]))
end

vim.keymap.set("n", "<C-h>", function()
	resize(true)
end, { silent = true })

vim.keymap.set("n", "<C-j>", function()
	resize(false)
end, { silent = true })
