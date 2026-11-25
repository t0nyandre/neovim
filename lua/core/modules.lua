-- Discovers lua/modules/<group>/<name>.lua and drives their lifecycle.
--
-- Module file shape (every field optional):
--   {
--     enabled  = true,                 -- default when the user config doesn't mention it
--     desc     = "short description",  -- shown in :checkhealth core
--     opts     = {},                   -- defaults, overridable from the user config
--     requires = { "rg" },             -- external executables, checked by :checkhealth core
--     mason    = { "pkg" },            -- mason packages to install
--     groups   = { { "<leader>g", group = "git" } }, -- which-key groups
--     init     = function(opts) end,   -- runs before lazy.nvim starts
--     plugins  = function(opts) return { ...lazy specs } end, -- or a plain table
--     setup    = function(opts) end,   -- runs after lazy.nvim is set up
--   }
--
-- A disabled module contributes nothing: no plugins, keymaps, autocmds or mason packages.

local config = require("core.config")
local util = require("core.util")

local M = {}

---@type table<string, table> all discovered modules by name ("group.name")
M.all = {}
---@type string[] enabled module names, in load order
M.enabled = {}

local loaded = false

function M.discover()
	if loaded then
		return
	end
	loaded = true

	for _, group in ipairs(util.scan_dirs("lua/modules")) do
		for _, file in ipairs(util.scan("lua/modules/" .. group)) do
			local name = group .. "." .. file
			local ok, mod = pcall(require, "modules." .. name)
			if not ok or type(mod) ~= "table" then
				vim.schedule(function()
					vim.notify(("Module %s failed to load:\n%s"):format(name, tostring(mod)), vim.log.levels.ERROR)
				end)
			else
				mod.name = name
				M.all[name] = mod
				if config.is_enabled("modules", name, mod.enabled) then
					mod.options = config.opts("modules", name, mod.opts)
					table.insert(M.enabled, name)
				end
			end
		end
	end
end

function M.is_enabled(name)
	M.discover()
	return vim.tbl_contains(M.enabled, name)
end

function M.get_opts(name)
	local mod = M.all[name]
	return mod and mod.options
end

local function each_enabled(fn)
	for _, name in ipairs(M.enabled) do
		local mod = M.all[name]
		local ok, err = pcall(fn, mod)
		if not ok then
			vim.schedule(function()
				vim.notify(("Module %s errored:\n%s"):format(name, err), vim.log.levels.ERROR)
			end)
		end
	end
end

function M.init()
	M.discover()
	each_enabled(function(mod)
		if mod.init then
			mod.init(mod.options)
		end
	end)
end

function M.plugins()
	local specs = {}
	each_enabled(function(mod)
		local p = mod.plugins
		if type(p) == "function" then
			p = p(mod.options)
		end
		vim.list_extend(specs, p or {})
	end)
	return specs
end

function M.setup()
	each_enabled(function(mod)
		if mod.setup then
			mod.setup(mod.options)
		end
	end)
end

--- Collect a list field (mason, requires, groups) from all enabled modules.
function M.collect(key)
	local result = {}
	for _, name in ipairs(M.enabled) do
		local value = M.all[name][key]
		if type(value) == "function" then
			value = value(M.all[name].options)
		end
		if key == "groups" then
			vim.list_extend(result, value or {})
		else
			util.extend_unique(result, value)
		end
	end
	return result
end

return M
