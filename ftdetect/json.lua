vim.filetype.add({
	pattern = {
		[".*"] = {
			function(path, bufnr)
				if not bufnr or vim.bo[bufnr].filetype ~= "" or path:match("%.%w+$") then
					return
				end

				local first_line = (vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""):sub(1, 100)
				if first_line:match("^%s*[{%[]") or first_line:match('^%s*"[^"]*"%s*:%s*') then
					return "json"
				end
			end,
			{ priority = -math.huge },
		},
	},
})
