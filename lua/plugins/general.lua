return {
	{
		"stevearc/oil.nvim",
		opts = {
			-- Disable automatic buffer cleanup to preserve jumplist navigation
			cleanup_delay_ms = false,
			view_options = {
				show_hidden = true,
			},
			win_options = {
				signcolumn = "yes:2",
				statuscolumn = "",
			},
		},
		dependencies = {
			{
				"nvim-tree/nvim-web-devicons",
				opts = {},
			},
			{
				"FerretDetective/oil-git-signs.nvim",
				ft = "oil",
				dependencies = { "stevearc/oil.nvim" },
				opts = {
					skip_confirm_for_simple_git_operations = true,
					keymaps = {
						{
							"n",
							"[h",
							function()
								require("oil-git-signs").jump_to_status("up", vim.v.count1)
							end,
						},
						{
							"n",
							"]h",
							function()
								require("oil-git-signs").jump_to_status("down", vim.v.count1)
							end,
						},
						{
							{ "n", "v" },
							"<Leader>hs",
							function()
								require("oil-git-signs").stage_selected()
							end,
						},
						{
							{ "n", "v" },
							"<Leader>hu",
							function()
								require("oil-git-signs").unstage_selected()
							end,
						},
					},
				},
			},
		},
		lazy = false,
		config = function(_, opts)
			require("oil").setup(opts)

			-- Track last oil directory for toggle functionality
			local last_oil_dir = nil
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "oil://*",
				callback = function()
					last_oil_dir = require("oil").get_current_dir()
				end,
			})

			-- Keymaps
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			vim.keymap.set("n", "<leader>-", function()
				if last_oil_dir then
					require("oil").open(last_oil_dir)
				else
					require("oil").open()
				end
			end, { desc = "Open oil at last directory" })
		end,
	},
	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		opts = {},
		config = function(_, _)
			-- document existing key chains
			require("which-key").add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>c_", hidden = true },
				{ "<leader>d", group = "[D]ebug" },
				{ "<leader>d_", hidden = true },
				{ "<leader>g", group = "[G]o" },
				{ "<leader>g_", hidden = true },
				{ "<leader>h", group = "[H]unk" },
				{ "<leader>h_", hidden = true },
				{ "<leader>f", group = "[F]ind" },
				{ "<leader>f_", hidden = true },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>t_", hidden = true },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>w_", hidden = true },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>s_", hidden = true },
			})
			-- register which-key VISUAL mode
			-- required for visual <leader>hs (hunk stage) to work
			require("which-key").add({
				{ "<leader>", group = "VISUAL <leader>", mode = "v" },
				{ "<leader>h", group = "Git [H]unk", mode = "v" },
			})
		end,
	},
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",

		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
				theme = "ayu",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						"filename",
						path = 1,
						on_click = function()
							local filepath = vim.fn.expand("%:.")
							if filepath and filepath ~= "" then
								vim.fn.setreg("+", filepath)
								vim.notify("File path copied to clipboard: " .. filepath, vim.log.levels.INFO)
							else
								vim.notify("No file to copy", vim.log.levels.WARN)
							end
						end,
					},
					"diagnostics",
				},
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
			},
			scope = {
				enabled = false,
			},
		},
	},

	-- Auto close brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			{
				"petertriho/nvim-scrollbar",
				opts = {},
			},
		},
		opts = {
			worktrees = {
				{
					toplevel = vim.env.HOME,
					gitdir = vim.env.HOME .. "/.dotfiles/",
				},
			},
			-- See `:help gitsigns.txt`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
				delay = 300,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			on_attach = function(bufnr)
				-- Setup scrollbar minimap
				require("scrollbar.handlers.gitsigns").setup()

				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map({ "n", "v" }, "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.nav_hunk("next", { target = "all" })
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to next hunk" })

				map({ "n", "v" }, "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.nav_hunk("prev", { target = "all" })
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to previous hunk" })

				-- Actions
				-- visual mode
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "stage git hunk" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "reset git hunk" })
				-- normal mode
				map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = false })
				end, { desc = "git blame line" })
				map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "git diff against last commit" })

				-- Toggles
				map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
				map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
			end,
		},
	},
}
