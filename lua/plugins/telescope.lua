local width = 0.9

local function document_symbol_layout()
	local full_width = vim.api.nvim_win_get_width(0)
	local available = math.floor(full_width * width) - 8
	local type_width = math.max(10, math.floor(available * 0.2))

	return {
		symbol_width = available - type_width,
		type_width = type_width,
	}
end

return {
	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",

		event = { "VeryLazy" },

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},

		config = function(_, _)
			local telescope = require("telescope")
			local lga_actions = require("telescope-live-grep-args.actions")

			telescope.setup({
				defaults = {
					borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
					file_ignore_patterns = {
						".git/",
						".cache",
						"%.o",
						"%.a",
						"%.out",
						"%.class",
						"%.pdf",
						"%.mkv",
						"%.mp4",
						"%.zip",
						"vendor/",
					},
					vimgrep_arguments = {
						"rg",
						"--hidden",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"-g",
						"!.git",
					},
					path_display = { "truncate" },
					layout_strategy = "vertical",
					layout_config = {
						height = 0.9,
						width = width,
						preview_cutoff = 1,
						prompt_position = "bottom",
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						-- define mappings, e.g.
						mappings = {
							-- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
								["<C-f>"] = lga_actions.quote_prompt({ postfix = " --fixed-strings" }),
							},
						},
					},
				},
			})

			telescope.load_extension("fzf")

			-- Show line numbers in preview
			vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

			-- Telescope background - link to floating window highlight for theme consistency
			vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
			vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "NormalFloat" })
			vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "NormalFloat" })
			vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { link = "NormalFloat" })
		end,

		keys = {
			{
				"<leader>ft",
				function()
					require("telescope.builtin").builtin()
				end,
				desc = "[F]ind [T]elescope",
			},
			{
				"<leader>fs",
				function()
					require("telescope.builtin").lsp_document_symbols(document_symbol_layout())
				end,
				desc = "[F]ind Document [S]ymbols",
			},
			{
				"<leader>fS",
				function()
					local symbol_type_width = 10
					local symbol_width = 50

					-- Get width of the terminal and resolve fname_width, symbol_width and symbol_type_width
					local full_width = vim.api.nvim_win_get_width(0)
					local available = full_width * width
					local fname_width = available - symbol_width - symbol_type_width

					if fname_width > 100 then
						fname_width = 100
					end

					require("telescope.builtin").lsp_dynamic_workspace_symbols({
						fname_width = fname_width,
						symbol_width = symbol_width,
						symbol_type_width = symbol_type_width,
					})
				end,
				desc = "[F]ind Workspace [S]ymbols",
			},
			{
				"<leader>fF",
				function()
					require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
				end,
				desc = "[F]ind All [F]iles (ignore .gitignore)",
			},
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "[F]ind [F]iles",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "[F]ind Git [H]unks",
			},
			{
				"<leader>f?",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "[F]ind [?]Help",
			},
			{
				"<leader>fG",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "[F]ind by [G]rep",
			},
			{
				"<leader>fg",
				function()
					require("telescope").extensions.live_grep_args.live_grep_args()
				end,
				desc = "[F]ind by [G]rep with Args",
			},
			{
				"<leader>fd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "[F]ind [D]iagnostics",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "[F]ind [R]esume",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "[F]ind [B]uffers",
			},
			{
				"<leader>fm",
				function()
					require("telescope.builtin").marks()
				end,
				desc = "[F]ind [M]arks",
			},
		},

		cmd = {
			"Telescope",
		},
	},
}
