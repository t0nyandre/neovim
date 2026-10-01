local languages = require("config.features")

local M = {}

--------------------------------------------------
-- Collect list-type entries
--
-- Example:
-- collect("treesitter")
-- collect("lsp")
-- collect("mason")
--------------------------------------------------

function M.collect(key)
	local result = {}
	local seen = {}

	-- Defaults first
	if languages._defaults then
		for _, item in ipairs(languages._defaults[key] or {}) do
			if not seen[item] then
				table.insert(result, item)
				seen[item] = true
			end
		end
	end

	-- Enabled languages
	for name, lang in pairs(languages) do
		if name ~= "_defaults" and lang.enabled then
			for _, item in ipairs(lang[key] or {}) do
				if not seen[item] then
					table.insert(result, item)
					seen[item] = true
				end
			end
		end
	end

	return result
end

--------------------------------------------------
-- Generate filetype maps
--
-- Example:
-- filetype_map("formatter")
-- filetype_map("linter")
--------------------------------------------------

function M.filetype_map(key)
	local result = {}

	for filetype, lang in pairs(languages) do
		if filetype ~= "_defaults" and lang.enabled then
			result[filetype] = lang[key] or {}
		end
	end

	return result
end

function M.enabled_lsps()
	return M.collect("lsp")
end

function M.lsp_configs()
	local result = {}

	for _, lang in pairs(languages) do
		if lang.enabled then
			for _, server in ipairs(lang.lsp or {}) do
				result[server] = lang.lsp_config or {}
			end
		end
	end

	return result
end

function M.enabled_tools()
	local result = {}

	if languages.tools then
		for tool, enabled in pairs(languages.tools) do
			if enabled then
				table.insert(result, tool)
			end
		end
	end

	return result
end

return M
