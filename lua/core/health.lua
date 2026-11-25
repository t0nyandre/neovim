-- :checkhealth core

local M = {}

local function check_executables(owner, list)
	for _, bin in ipairs(list or {}) do
		if vim.fn.executable(bin) == 1 then
			vim.health.ok(("%s: `%s` found"):format(owner, bin))
		else
			vim.health.warn(("%s: `%s` not found in PATH"):format(owner, bin))
		end
	end
end

function M.check()
	local config = require("core.config")
	local modules = require("core.modules")
	local languages = require("core.languages")
	modules.discover()
	languages.discover()

	vim.health.start("Neovim")
	if vim.fn.has("nvim-0.11") == 1 then
		vim.health.ok("Neovim " .. tostring(vim.version()))
	else
		vim.health.error("Neovim 0.11+ is required")
	end

	vim.health.start("User config")
	for section, registry in pairs({ modules = modules.all, languages = languages.all }) do
		for name in pairs(config.options[section]) do
			if not registry[name] then
				vim.health.warn(("Unknown %s entry `%s` in lua/user/config.lua"):format(section, name))
			end
		end
	end
	vim.health.info("Colorscheme: " .. config.options.colorscheme)

	vim.health.start("Modules")
	local names = vim.tbl_keys(modules.all)
	table.sort(names)
	for _, name in ipairs(names) do
		local mod = modules.all[name]
		local label = ("%s%s"):format(name, mod.desc and (" — " .. mod.desc) or "")
		if modules.is_enabled(name) then
			vim.health.ok(label)
		else
			vim.health.info("(disabled) " .. label)
		end
	end

	vim.health.start("Languages")
	names = vim.tbl_keys(languages.all)
	table.sort(names)
	for _, name in ipairs(names) do
		local lang = languages.all[name]
		if vim.tbl_contains(languages.enabled, name) then
			vim.health.ok(("%s (%s)"):format(name, table.concat(lang.filetypes or {}, ", ")))
		else
			vim.health.info("(disabled) " .. name)
		end
	end

	vim.health.start("External tools")
	for _, name in ipairs(modules.enabled) do
		check_executables(name, modules.all[name].requires)
	end
	for _, name in ipairs(languages.enabled) do
		check_executables(name, languages.all[name].requires)
	end

	vim.health.start("Toggles")
	for name, t in pairs(require("core.toggles").list()) do
		vim.health.info(("%s: %s"):format(name, t.value and "on" or "off"))
	end
end

return M
