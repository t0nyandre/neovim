-- Merges lua/user/config.lua over the defaults and answers "is X enabled / what are X's options".
--
-- A module or language entry in the user config can be:
--   nil    -> use the module's own `enabled` default
--   false  -> disabled
--   true   -> enabled with default options
--   table  -> enabled, table is deep-merged over the module's default `opts`
--             (set `enabled = false` inside the table to keep the overrides but disable it)

local M = {}

local defaults = {
	colorscheme = "kanagawa",
	modules = {},
	languages = {},
}

local ok, user = pcall(require, "user.config")
if not ok then
	vim.schedule(function()
		vim.notify("Failed to load lua/user/config.lua:\n" .. tostring(user), vim.log.levels.ERROR)
	end)
	user = {}
end

M.options = vim.tbl_deep_extend("force", defaults, type(user) == "table" and user or {})

---@param section "modules"|"languages"
---@param name string
---@param default_enabled boolean|nil
function M.is_enabled(section, name, default_enabled)
	local value = M.options[section][name]
	if value == nil then
		return default_enabled ~= false
	end
	if type(value) == "table" then
		return value.enabled ~= false
	end
	return value == true
end

---@param section "modules"|"languages"
---@param name string
---@param default_opts table|nil
function M.opts(section, name, default_opts)
	local value = M.options[section][name]
	local base = vim.deepcopy(default_opts or {})
	if type(value) ~= "table" then
		return base
	end
	local overrides = vim.deepcopy(value)
	overrides.enabled = nil
	return vim.tbl_deep_extend("force", base, overrides)
end

return M
