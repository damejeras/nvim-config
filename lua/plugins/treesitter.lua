return {
	{
		"hedyhli/outline.nvim",
		config = function()
			-- Example mapping to toggle outline
			vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

			require("outline").setup({
				-- Your setup opts here (leave empty to use defaults)
			})
		end,
	},
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
			{
				-- Tree-sitter incremental selection plugin
				-- Replaces the removed incremental_selection from nvim-treesitter
				"daliusd/incr.nvim",
				opts = {
					incr_key = "m", -- Grow selection
					decr_key = "M", -- Shrink selection
				},
			},
		},
		build = ":TSUpdate",
		config = function(_, _)
			-- [[ Configure Treesitter ]]
			-- NOTE: This is the `main` branch of nvim-treesitter, which has a
			-- different API from `master`: setup() takes no ensure_installed and
			-- there are no highlight/indent modules. Parsers are installed with
			-- install() (skips anything already installed), and highlighting and
			-- indentation are enabled per-buffer via vim.treesitter.
			require("nvim-treesitter").install({
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
				"markdown_inline",
				"zig",
				"ruby",
				"gitcommit",
				"git_rebase",
				"git_config",
				"gitattributes",
				"gitignore",
				"toml",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", {}),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match)
					if lang and vim.treesitter.language.add(lang) then
						-- Also highlights injected languages, e.g. code fences in markdown
						vim.treesitter.start(ev.buf, lang)
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
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
