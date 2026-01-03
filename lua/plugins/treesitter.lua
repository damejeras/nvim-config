return {
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				init = function()
					-- IMPORTANT: Disable built-in ftplugin mappings to avoid conflicts.
					-- Neovim has built-in text object mappings (like 'if' for Lua files)
					-- that would override our treesitter-textobjects mappings.
					-- This setting prevents those conflicts.
					vim.g.no_plugin_maps = true
				end,
			},
		},
		build = ":TSUpdate",
		config = function(_, _)
			-- [[ Configure Treesitter ]]
			require("nvim-treesitter").setup({
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = {
					"c",
					"cpp",
					"go",
					"templ",
					"lua",
					"python",
					"rust",
					"tsx",
					"javascript",
					"typescript",
					"vimdoc",
					"vim",
					"bash",
					"yaml",
					"markdown",
					"zig",
					"ruby",
				},

				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = false,
				-- Install languages synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- List of parsers to ignore installing
				ignore_install = {},
				-- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
				modules = {},
				highlight = { enable = true },
				indent = { enable = true },
			})

			-- Configure treesitter-textobjects separately.
			-- NOTE: In newer versions of nvim-treesitter-textobjects, the API changed:
			-- - Must call require("nvim-treesitter-textobjects").setup() separately
			-- - Cannot use require("nvim-treesitter.configs") (doesn't exist anymore)
			-- - Must manually register keymaps with vim.keymap.set()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					include_surrounding_whitespace = false,
				},
				move = {
					set_jumps = true, -- whether to set jumps in the jumplist
				},
			})

			-- Set up text object keymaps manually.
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Select outer function" })
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inner function" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "Select outer class" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inner class" })
			vim.keymap.set({ "x", "o" }, "aa", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end, { desc = "Select outer parameter" })
			vim.keymap.set({ "x", "o" }, "ia", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end, { desc = "Select inner parameter" })

			-- Set up move keymaps
			local move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end, { desc = "Next class end" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Previous function start" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Previous class start" })
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Previous function end" })
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end, { desc = "Previous class end" })
		end,
	},
}
