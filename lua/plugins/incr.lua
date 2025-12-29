return {
	{
		-- Tree-sitter incremental selection plugin
		-- Replaces the removed incremental_selection from nvim-treesitter
		"daliusd/incr.nvim",
		opts = {
			incr_key = "v", -- Grow selection
			decr_key = "V", -- Shrink selection
		},
	},
}
