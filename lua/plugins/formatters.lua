return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- These are on PATH already on NixOS, where mason's downloads do not run. Ask
			-- mason only for what is actually missing, so the config stays portable to a
			-- machine that provides none of them.
			ensure_installed = vim.tbl_filter(function(tool)
				return vim.fn.executable(tool) == 0
			end, {
				"goimports",
				"gofumpt",
				"stylua",
				"prettier",
				"buf",
				"ruff",
			}),
			auto_update = false,
			run_on_start = true,
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Define formatters for each filetype
			formatters_by_ft = {
				go = { "goimports", "gofumpt" },
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				terraform = { "terraform_fmt" },
				proto = { "buf" },
			},
			-- Format on save
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
