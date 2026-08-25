-- A jump leaves the cursor where the target line already sat, so a definition near the
-- bottom of the window keeps its body off screen. Frame the definition instead: put the
-- node the cursor landed in in the middle of the window, and fall back to zz when the
-- node is taller than the window.
local function frame_node()
	local win = 0
	local row = vim.api.nvim_win_get_cursor(win)[1] - 1

	-- The jump can land before anything drew the new buffer, and get_node reads parsed
	-- trees only, so parse first or there is no node to frame.
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if not ok or not parser then
		vim.cmd("normal! zz")
		return
	end
	parser:parse()

	local node = vim.treesitter.get_node()
	if not node then
		vim.cmd("normal! zz")
		return
	end

	-- The cursor lands on the name, so climb to the largest node that still starts on
	-- that line: from a function name that is the whole declaration. Stop below the
	-- root, which starts on the first line and spans the file.
	while node:parent() and node:parent():parent() and node:parent():start() == row do
		node = node:parent()
	end

	local first, _, last, _ = node:range()
	local height = vim.api.nvim_win_get_height(win)
	-- 'wrap' is on, so the line count of a node is not the space it takes on screen.
	local rows = vim.api.nvim_win_text_height(win, { start_row = first, end_row = last }).all
	if rows > height then
		vim.cmd("normal! zz")
		return
	end

	-- Half of the space that is left goes above the node. Walk up line by line until
	-- that space is full: with wrap on, one line can take more than one row.
	local above = math.floor((height - rows) / 2)
	local top = first
	while top > 0 do
		local line = vim.api.nvim_win_text_height(win, { start_row = top - 1, end_row = top - 1 }).all
		if line > above then
			break
		end
		above = above - line
		top = top - 1
	end

	vim.fn.winrestview({ topline = top + 1 })
end

-- Both jump paths land after the call returns: one result jumps from the LSP reply,
-- several go through the telescope picker. So arm the framing and let the landing run
-- it. A jump that finds nothing never lands and leaves the arm set, which spends itself
-- on the next cursor move.
local function framed(jump)
	return function()
		jump()
		local group = vim.api.nvim_create_augroup("LspJumpFrame", { clear = true })
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group,
			callback = function(ev)
				-- The picker moves its own cursor first. Only a file window is a landing.
				if vim.bo[ev.buf].buftype ~= "" then
					return
				end
				vim.api.nvim_del_augroup_by_id(group)
				vim.schedule(frame_node)
			end,
		})
	end
end

return {
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			-- opts (not a manual setup() call) so mason also configures itself when
			-- another plugin, such as nvim-treesitter, loads it as a dependency.
			{ "mason-org/mason.nvim", version = "1.11.0", opts = {} },
			{ "towolf/vim-helm", ft = "helm" },
			{ "cenk1cenk2/schema-companion.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
			{
				"mason-org/mason-lspconfig.nvim",
				version = "1.32.0",
				config = function(_, _)
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

						nmap("gd", framed(require("telescope.builtin").lsp_definitions), "[G]oto [D]efinition")
						nmap("gr", framed(require("telescope.builtin").lsp_references), "[G]oto [R]eferences")
						nmap("gi", framed(require("telescope.builtin").lsp_implementations), "[G]oto [I]mplementation")
						nmap("gI", framed(require("telescope.builtin").lsp_implementations), "[G]oto [I]mplementation")

						-- See `:help K` for why this keymap
						nmap("K", vim.lsp.buf.hover, "Hover Documentation")

						-- Lesser used LSP functionality
						nmap("gD", framed(vim.lsp.buf.declaration), "[G]oto [D]eclaration")
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
						pyright = {},
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
								usePlaceholders = false,
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
							},
						},
					}

					-- A file name cannot say "this is a Kubernetes manifest", so this reads the
					-- buffer and answers that one question. It hands back the keyword, not a
					-- schema URL: yaml-language-server resolves "kubernetes" per document, so
					-- each document in a multi-document file gets the schema for its own kind,
					-- and a group it does not ship goes to the CRD catalog. The plugin's own
					-- kubernetes matcher resolves the URL itself, which pins every kind found
					-- anywhere in the file onto every document in it.
					local kubernetes_source = {
						name = "Kubernetes",
						match = function(_, ctx, bufnr)
							-- A file the catalog names on its own keeps that schema. kind.yaml carries
							-- apiVersion and kind but describes a kind cluster, not a resource in one,
							-- and the keyword sends yamlls to a CRD url that does not exist. Skip what
							-- our own override put there, or a second match would stand down.
							for _, schema in ipairs(ctx.adapter:match_schema_from_lsp(bufnr) or {}) do
								local uri = schema.uri or ""
								if not uri:match("kubernetes%-json%-schema") and not uri:match("CRDs%-catalog") then
									return {}
								end
							end

							local api, kind = false, false
							for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
								api = api or line:match("^apiVersion:%s*%S") ~= nil
								kind = kind or line:match("^kind:%s*%S") ~= nil
							end

							if api and kind then
								return { { name = "Kubernetes", uri = "kubernetes", source = "Kubernetes" } }
							end

							return {}
						end,
					}

					-- schema-companion's README says to configure the servers from after/lsp/,
					-- which does not work here: the vim.lsp.config assignment below outranks
					-- every lsp/ file on the runtimepath, so it would drop the adapter's
					-- on_attach and capabilities.
					local schema_adapters = {
						yamlls = function()
							local sc = require("schema-companion")
							return sc.adapters.yamlls.setup({
								sources = { kubernetes_source, sc.sources.lsp.setup() },
							})
						end,
						helm_ls = function()
							local sc = require("schema-companion")
							return sc.adapters.helmls.setup({
								sources = { kubernetes_source },
							})
						end,
					}

					-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
					-- Disable snippet support since we don't use a snippet engine
					capabilities.textDocument.completion.completionItem.snippetSupport = false

					-- Ensure the servers above are installed
					local mason_lspconfig = require("mason-lspconfig")

					mason_lspconfig.setup({
						ensure_installed = vim.tbl_keys(servers),
					})

					mason_lspconfig.setup_handlers({
						function(server_name)
							local config = {
								capabilities = capabilities,
								on_attach = on_attach,
								settings = servers[server_name],
								filetypes = (servers[server_name] or {}).filetypes,
							}

							if schema_adapters[server_name] then
								config =
									require("schema-companion").setup_client(schema_adapters[server_name](), config)
							end

							vim.lsp.config[server_name] = config
							vim.lsp.enable(server_name)
						end,
					})
				end,
			},
		},
	},
}
