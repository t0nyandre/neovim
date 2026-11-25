local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
		return false
	end
end

vim.opt.rtp:prepend(lazypath)

local modules = require("core.modules")
local languages = require("core.languages")

-- lazy.nvim resets the runtimepath and only keeps <prefix>/lib/nvim. Distro builds may ship
-- the bundled parsers elsewhere (e.g. Debian's /usr/lib/x86_64-linux-gnu/nvim), so keep any
-- lib dir that holds parsers - :helptags needs the vimdoc parser on Neovim 0.12+.
local keep_paths = {}
for _, path in ipairs(vim.opt.rtp:get()) do
	if path:match("/lib/") and vim.uv.fs_stat(path .. "/parser") then
		table.insert(keep_paths, path)
	end
end

local spec = modules.plugins()
vim.list_extend(spec, languages.plugins())

require("lazy").setup({
	spec = spec,
	install = { colorscheme = { require("core.config").options.colorscheme, "habamax" } },
	change_detection = { notify = false },
	rocks = { enabled = false }, -- no plugin needs luarocks
	performance = {
		rtp = {
			paths = keep_paths,
			disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})

return true
