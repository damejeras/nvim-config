return {
	{
		"coder/claudecode.nvim",
		-- Eager, because the plugin is the server, not the client: it opens the WebSocket
		-- and writes ~/.claude/ide/<port>.lock, and a Claude session started before this
		-- Neovim can only find it with /ide if it is already listening. Lazy loading would
		-- start it at the first <leader>a mapping, which is after the moment it is needed.
		lazy = false,
		opts = {
			-- `claude` on this box is a zsh function, which Neovim cannot call. Spawn the
			-- script the function wraps: it is the one record of how a session starts here.
			terminal_cmd = vim.env.HOME .. "/.shell/modules/claude/claude-session",
			terminal = {
				provider = "native",
				split_side = "right",
				split_width_percentage = 0.35,
			},
			diff_opts = {
				layout = "vertical",
			},
		},
		keys = {
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
			{ "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file to Claude", ft = "neo-tree" },
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
