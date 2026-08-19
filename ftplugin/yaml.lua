-- Basic settings
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

vim.keymap.set("n", "<leader>cy", function()
	require("schema-companion").select_schema()
end, { buffer = true, desc = "LSP: [C]ode [Y]AML schema" })
