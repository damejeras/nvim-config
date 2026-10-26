local autocmd = vim.api.nvim_create_autocmd

-- Clear jump list on start, so you would not jump to previous projects.
autocmd("VimEnter", {
	callback = function()
		vim.cmd.clearjumps()
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = true,
			focus = false,
			scope = "cursor",
			border = "none",
		})
	end,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
