return {
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			{ "mason-org/mason.nvim", version = "1.11.0" },
			{ "towolf/vim-helm", ft = "helm" },
			{
				"mason-org/mason-lspconfig.nvim",
				version = "1.32.0",
				config = function(_, _)
					-- mason-lspconfig requires that these setup functions are called in this order
					-- before setting up the servers.
					require("mason").setup()

					-- [[ Configure LSP ]]
					--  This function gets run when an LSP connects to a particular buffer.
					local on_attach = function(_, bufnr)
						-- NOTE: Remember that lua is a real programming language, and as such it is possible
						-- to define small helper and utility functions so you don't have to repeat yourself
						-- many times.
						--
						-- In this case, we create a function that lets us more easily define mappings specific
						-- for LSP related items. It sets the mode, buffer and description for us each time.
						local nmap = function(keys, func, desc)
							if desc then
								desc = "LSP: " .. desc
							end

							vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
						end

						nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
						nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
						nmap("<leader>cf", "<cmd>Format<CR>", "[C]ode [F]ormat")
						nmap("<leader>cs", vim.lsp.buf.signature_help, "[C]ode [S]ignature")

						nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
						nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
						nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

						-- See `:help K` for why this keymap
						nmap("K", vim.lsp.buf.hover, "Hover Documentation")

						-- Lesser used LSP functionality
						nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
						nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
						nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
						nmap("<leader>wl", function()
							print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						end, "[W]orkspace [L]ist Folders")

						-- Create a command `:Format` local to the LSP buffer
						vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
							vim.lsp.buf.format()
						end, { desc = "Format current buffer with LSP" })
					end

					-- Enable the following language servers
					--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
					--
					--  Add any additional override configuration in the following tables. They will be passed to
					--  the `settings` field of the server config. You must look up that documentation yourself.
					--
					--  If you want to override the default filetypes that your language server will attach to you can
					--  define the property 'filetypes' to the map in question.
					local servers = {
						-- clangd = {},
						-- pyright = {},
						-- rust_analyzer = {},
						-- tsserver = {},
						-- html = { filetypes = { 'html', 'twig', 'hbs'} },

						-- phpactor = {},
						lua_ls = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME,
										"${3rd}/luv/library",
									},
								},
								telemetry = {
									enable = false,
								},
							},
						},
						gopls = {
							gopls = {
								env = { GOFLAGS = "-tags=unit", GOOS = "linux" },
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
								analyses = {
									unusedfunc = true, -- NEW: Real-time dead function detection
									unusedparams = true, -- Improved unused parameter detection
									unusedwrite = true, -- Detects writes to variables never read
									unusedvariable = true, -- Local unused variables
									unreachable = true, -- Unreachable code after returns/panics
									nilness = true, -- Nil pointer analysis
								},
								-- Enable comprehensive static analysis
								staticcheck = true, -- Includes U1000 series for unused code

								-- Enhanced completion and formatting
								completeUnimported = true,
								gofumpt = true,
								usePlaceholders = true,
								-- Performance optimization for large projects
								directoryFilters = {
									"-.git",
									"-.vscode",
									"-.idea",
									"-node_modules",
									"-vendor",
								},
								templateExtensions = { "pb.go" },
							},
						},
						zls = {},
						templ = {},
						terraformls = {},
						helm_ls = {
							["helm-ls"] = {
								yamlls = {
									path = "yaml-language-server",
								},
								valuesFiles = {
									mainValuesFile = "values.yaml",
									lintOverlayValuesFile = "values.lint.yaml",
									additionalValuesFilesGlobPattern = "values*.yaml",
								},
							},
						},
						yamlls = {
							yaml = {
								format = {
									enabled = true,
								},
								schemas = {
									kubernetes = "*!(values).yaml",
									["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
									["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
									["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
									["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
									["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
									["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
									["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
									["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
									["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
									["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
									["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
									["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
									["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "argocd-application.yaml",
								},
							},
						},
					}

					-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

					-- Ensure the servers above are installed
					local mason_lspconfig = require("mason-lspconfig")

					mason_lspconfig.setup({
						ensure_installed = vim.tbl_keys(servers),
					})

					mason_lspconfig.setup_handlers({
						function(server_name)
							vim.lsp.config[server_name] = {
								capabilities = capabilities,
								on_attach = on_attach,
								settings = servers[server_name],
								filetypes = (servers[server_name] or {}).filetypes,
							}
							vim.lsp.enable(server_name)
						end,
					})
				end,
			},
		},
	},
}
