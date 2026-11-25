vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- No remote plugins in use: skip the node/python/perl/ruby provider lookups.
for _, provider in ipairs({ "node", "python3", "perl", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.mouse = "a"
opt.confirm = true
opt.undofile = true

opt.splitbelow = true
opt.splitright = true

opt.updatetime = 250
opt.timeoutlen = 300

-- Deferred: the clipboard provider lookup is slow (especially on WSL).
vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)

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
		source = true,
	},
})
