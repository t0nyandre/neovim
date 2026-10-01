local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4

opt.smartindent = true
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.splitbelow = true
opt.splitright = true

opt.updatetime = 250
opt.timeoutlen = 300

opt.clipboard = "unnamedplus"

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},

	signs = true,

	underline = true,

	update_in_insert = false,

	severity_sort = true,

	float = {
		border = "rounded",
		source = "always",
	},
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
