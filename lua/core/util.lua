local M = {}

--- Append items of `src` to `dst`, skipping duplicates.
function M.extend_unique(dst, src, seen)
	seen = seen or {}
	for _, item in ipairs(dst) do
		seen[item] = true
	end
	for _, item in ipairs(src or {}) do
		if not seen[item] then
			seen[item] = true
			table.insert(dst, item)
		end
	end
	return dst
end

--- List the lua module basenames in a directory of this config (e.g. "lua/languages").
function M.scan(relative_dir)
	local dir = vim.fs.joinpath(vim.fn.stdpath("config"), relative_dir)
	local names = {}
	for name, kind in vim.fs.dir(dir) do
		if kind == "file" and name:match("%.lua$") and not name:match("^_") then
			table.insert(names, (name:gsub("%.lua$", "")))
		end
	end
	table.sort(names)
	return names
end

--- List subdirectories of a directory of this config.
function M.scan_dirs(relative_dir)
	local dir = vim.fs.joinpath(vim.fn.stdpath("config"), relative_dir)
	local names = {}
	for name, kind in vim.fs.dir(dir) do
		if kind == "directory" then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end

--- The outermost directory above `buf` that contains `marker`, without leaving the git repo
--- (or $HOME when not in one). For build systems whose subdirectories carry the same marker,
--- e.g. CMake: src/CMakeLists.txt must not be mistaken for the project root.
---@param buf integer
---@param marker string
---@return string|nil
function M.outermost_root(buf, marker)
	local name = vim.api.nvim_buf_get_name(buf)
	local start = name ~= "" and vim.fs.dirname(vim.fs.normalize(name)) or vim.fn.getcwd()
	local git = vim.fs.root(start, ".git")
	local stop = git and vim.fs.dirname(git) or vim.uv.os_homedir()
	local found = vim.fs.find(marker, { path = start, upward = true, stop = stop, limit = math.huge })
	local last = found[#found]
	return last and vim.fs.dirname(last) or nil
end

M.is_wsl = vim.fn.has("wsl") == 1

return M
