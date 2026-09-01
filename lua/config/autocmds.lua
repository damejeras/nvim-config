local autocmd = vim.api.nvim_create_autocmd

-- Clear jump list on start, so you would not jump to previous projects.
autocmd("VimEnter", {
	callback = function()
		vim.cmd.clearjumps()
	end,
})

-- Open telescope when nvim starts on a directory, instead of a file tree.
autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() ~= 1 or vim.fn.isdirectory(vim.fn.argv(0)) == 0 then
			return
		end
		vim.cmd.cd(vim.fn.argv(0))
		-- Replace the directory buffer with an empty one, so quitting telescope
		-- leaves a normal buffer and not a directory listing.
		local dir_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, false))
		vim.api.nvim_buf_delete(dir_buf, { force = true })
		require("telescope.builtin").find_files({ hidden = true })
	end,
})

-- Detect JSON when files don't have .json extension. Could backfire, but had no problems yet.
autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		-- Skip if filetype is already set or buffer has a name
		if vim.bo.filetype ~= "" then
			return
		end

		local filename = vim.fn.expand("%")
		if filename ~= "" then
			-- If file has an extension, let Neovim handle filetype detection
			if filename:match("%.%w+$") then
				return
			end
		end

		-- Only check first line with a maximum of 100 characters
		local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
		if not first_line then
			return
		end

		first_line = first_line:sub(1, 100)

		-- Quick pattern match for common JSON starts
		if first_line:match("^%s*[{%[]") or first_line:match('^%s*"[^"]*"%s*:%s*') then
			vim.bo.filetype = "json"
		end
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

-- Close diagnostic floating windows only when using jumplist navigation
vim.keymap.set("n", "<C-o>", function()
	vim.diagnostic.hide()
	return "<C-o>"
end, { expr = true })

vim.keymap.set("n", "<C-i>", function()
	vim.diagnostic.hide()
	return "<C-i>"
end, { expr = true })
