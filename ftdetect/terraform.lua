vim.filetype.add({
	extension = {
		terraformrc = "hcl",
		tfstate = "json",
	},
	filename = {
		["terraform.rc"] = "hcl",
	},
})
