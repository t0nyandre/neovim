-- Discovers lua/languages/<name>.lua and merges what enabled languages declare.
--
-- Language file shape (every field optional except filetypes):
--   {
--     enabled    = true,
--     filetypes  = { "c", "cpp" },
--     treesitter = { "c", "cpp" },                  -- parsers to install
--     lsp        = { clangd = { ... } },            -- server -> vim.lsp.Config (or function returning one)
--     formatters = { c = { "clang_format" } },      -- filetype -> conform formatters
--     linters    = { c = { "cpplint" } },           -- filetype -> nvim-lint linters
--     mason      = { "clangd", "clang-format" },    -- mason packages
--     requires   = { "node" },                      -- external executables (health check)
--     plugins    = { ...lazy specs },               -- extra plugins this language needs
--     provider   = { actions = { run = ... } },      -- core.actions provider (run/build/test)
--     dap        = { adapters = { gdb = {...} },     -- nvim-dap adapters + filetype -> configurations
--                    configurations = { cpp = {...} } }, -- (or a function(opts) returning that)
--     buffer     = function(buf, opts) end,         -- per-buffer settings on FileType
--     opts       = {},                              -- defaults, overridable from the user config
--   }
--
-- When several languages declare the same LSP server, their configs are deep-merged.

local config = require("core.config")
local util = require("core.util")

local M = {}

M.all = {}
M.enabled = {}

local loaded = false

function M.discover()
	if loaded then
		return
	end
	loaded = true

	for _, name in ipairs(util.scan("lua/languages")) do
		local ok, lang = pcall(require, "languages." .. name)
		if not ok or type(lang) ~= "table" then
			vim.schedule(function()
				vim.notify(("Language %s failed to load:\n%s"):format(name, tostring(lang)), vim.log.levels.ERROR)
			end)
		else
			lang.name = name
			M.all[name] = lang
			if config.is_enabled("languages", name, lang.enabled) then
				lang.options = config.opts("languages", name, lang.opts)
				table.insert(M.enabled, name)
			end
		end
	end
end

local function each(fn)
	M.discover()
	for _, name in ipairs(M.enabled) do
		fn(M.all[name])
	end
end

--- Deduplicated list field across enabled languages (treesitter, mason, requires, filetypes).
function M.collect(key)
	local result = {}
	each(function(lang)
		util.extend_unique(result, lang[key])
	end)
	return result
end

--- filetype -> value map (formatters, linters). Later languages win on conflicts.
function M.by_filetype(key)
	local result = {}
	each(function(lang)
		for ft, value in pairs(lang[key] or {}) do
			result[ft] = value
		end
	end)
	return result
end

--- server -> merged vim.lsp.Config. Functions are resolved here, so call this after lazy setup.
function M.servers()
	local result = {}
	each(function(lang)
		for server, cfg in pairs(lang.lsp or {}) do
			if type(cfg) == "function" then
				cfg = cfg(lang.options)
			end
			result[server] = vim.tbl_deep_extend("force", result[server] or {}, cfg or {})
		end
	end)
	return result
end

--- Merged nvim-dap spec: { adapters = name -> adapter, configurations = filetype -> list }.
--- Functions are resolved here, so call this once nvim-dap is loaded.
function M.dap()
	local result = { adapters = {}, configurations = {} }
	each(function(lang)
		local spec = lang.dap
		if type(spec) == "function" then
			spec = spec(lang.options)
		end
		for name, adapter in pairs(spec and spec.adapters or {}) do
			result.adapters[name] = adapter
		end
		for ft, list in pairs(spec and spec.configurations or {}) do
			result.configurations[ft] = vim.list_extend(result.configurations[ft] or {}, list)
		end
	end)
	return result
end

function M.plugins()
	local specs = {}
	each(function(lang)
		vim.list_extend(specs, lang.plugins or {})
	end)
	return specs
end

function M.setup()
	local actions = require("core.actions")
	local group = vim.api.nvim_create_augroup("core.languages", { clear = true })

	each(function(lang)
		if lang.provider then
			actions.register(vim.tbl_extend("keep", lang.provider, { name = lang.name, filetypes = lang.filetypes }))
		end
		if lang.buffer then
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = lang.filetypes,
				callback = function(ev)
					lang.buffer(ev.buf, lang.options)
				end,
			})
		end
	end)
end

return M
