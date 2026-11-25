-- Runtime toggles under <leader>u, persisted to stdpath("state")/toggles.json.
--
-- Modules register their own toggles:
--   require("core.toggles").register({
--     name = "format_on_save", key = "f", desc = "Format on save",
--     default = true, apply = function(enabled) ... end,  -- apply is optional
--   })
-- and read them with require("core.toggles").get("format_on_save").

local M = {}

local state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "toggles.json")
local saved = nil
local registry = {}

local function read_state()
	if saved then
		return saved
	end
	saved = {}
	local fd = io.open(state_file, "r")
	if fd then
		local ok, data = pcall(vim.json.decode, fd:read("*a"))
		fd:close()
		if ok and type(data) == "table" then
			saved = data
		end
	end
	return saved
end

local function write_state()
	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	local fd = io.open(state_file, "w")
	if fd then
		fd:write(vim.json.encode(read_state()))
		fd:close()
	end
end

function M.get(name)
	local t = registry[name]
	if not t then
		return true
	end
	return t.value
end

function M.set(name, value)
	local t = registry[name]
	if not t then
		return
	end
	t.value = value
	if t.apply then
		t.apply(value)
	end
	read_state()[name] = value
	write_state()
end

function M.toggle(name)
	local t = registry[name]
	if not t then
		return
	end
	M.set(name, not t.value)
	vim.notify(("%s %s"):format(t.desc, t.value and "enabled" or "disabled"), vim.log.levels.INFO, { title = "Toggle" })
end

function M.register(spec)
	local state = read_state()
	local value = state[spec.name]
	if value == nil then
		value = spec.default ~= false
	end
	spec.value = value
	registry[spec.name] = spec
	if spec.apply then
		spec.apply(value)
	end
	if spec.key then
		vim.keymap.set("n", "<leader>u" .. spec.key, function()
			M.toggle(spec.name)
		end, { desc = "Toggle " .. spec.desc })
	end
end

function M.list()
	return registry
end

--- Set a window option in every window (wrap, spell, relativenumber are window-local).
local function window_option(option)
	return function(value)
		vim.o[option] = value
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			vim.wo[win][option] = value
		end
	end
end

--- Built-in toggles that don't belong to a specific module.
function M.setup()
	M.register({
		name = "diagnostics",
		key = "d",
		desc = "Diagnostics",
		apply = function(v)
			vim.diagnostic.enable(v)
		end,
	})
	M.register({
		name = "inlay_hints",
		key = "h",
		desc = "Inlay hints",
		default = false,
		apply = function(v)
			vim.lsp.inlay_hint.enable(v)
		end,
	})
	M.register({ name = "wrap", key = "w", desc = "Wrap", default = false, apply = window_option("wrap") })
	M.register({ name = "spell", key = "s", desc = "Spell", default = false, apply = window_option("spell") })
	M.register({
		name = "relativenumber",
		key = "r",
		desc = "Relative number",
		apply = window_option("relativenumber"),
	})
end

return M
