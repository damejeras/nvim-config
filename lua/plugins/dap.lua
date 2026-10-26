return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				opts = {
					dap_configurations = {
						{
							-- Must be "go" or it will be ignored by the plugin
							type = "go",
							name = "Attach remote",
							mode = "remote",
							request = "attach",
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>dc",
				"<cmd>DapContinue<CR>",
				desc = "[D]ebug [C]ontinue",
			},
			{
				"<leader>db",
				"<cmd>DapToggleBreakpoint<CR>",
				desc = "[D]ebug [B]reakpoint Toggle",
			},
			{
				"<leader>dr",
				"<cmd>DapToggleRepl<CR>",
				desc = "[D]ebug [R]epl Toggle",
			},
			{
				"<leader>dj",
				"<cmd>DapStepOver<CR>",
				desc = "[D]ebug Over (Down [j])",
			},
			{
				"<leader>dh",
				"<cmd>DapStepOut<CR>",
				desc = "[D]ebug Out (Left [h])",
			},
			{
				"<leader>dl",
				"<cmd>DapStepInto<CR>",
				desc = "[D]ebug Into (Right [l])",
			},
		},
	},
}
