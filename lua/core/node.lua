-- Shared helpers for the javascript / typescript / vue languages.

local M = {}

M.js_filetypes = { "javascript", "javascriptreact" }
M.ts_filetypes = { "typescript", "typescriptreact" }

--- conform formatter list: prettierd, falling back to prettier.
M.prettier = { "prettierd", "prettier", stop_after_first = true }

local lockfiles = {
	{ "bun.lock", "bun" },
	{ "bun.lockb", "bun" },
	{ "pnpm-lock.yaml", "pnpm" },
	{ "yarn.lock", "yarn" },
	{ "package-lock.json", "npm" },
}

function M.package_manager(root)
	for _, entry in ipairs(lockfiles) do
		if vim.uv.fs_stat(vim.fs.joinpath(root, entry[1])) then
			return entry[2]
		end
	end
	return "npm"
end

function M.scripts(root)
	local fd = io.open(vim.fs.joinpath(root, "package.json"), "r")
	if not fd then
		return {}
	end
	local ok, pkg = pcall(vim.json.decode, fd:read("*a"))
	fd:close()
	return ok and type(pkg) == "table" and type(pkg.scripts) == "table" and pkg.scripts or {}
end

--- Read package.json and check whether any (dev)dependency name contains `needle`.
function M.has_dependency(root, needle)
	local fd = io.open(vim.fs.joinpath(root, "package.json"), "r")
	if not fd then
		return false
	end
	local ok, pkg = pcall(vim.json.decode, fd:read("*a"))
	fd:close()
	if not ok or type(pkg) ~= "table" then
		return false
	end
	for _, key in ipairs({ "dependencies", "devDependencies" }) do
		for name in pairs(type(pkg[key]) == "table" and pkg[key] or {}) do
			if name:find(needle, 1, true) then
				return true
			end
		end
	end
	return false
end

--- Returns an action that runs the first existing script of `candidates`.
local function script_action(candidates)
	return function(ctx)
		local scripts = M.scripts(ctx.root)
		for _, script in ipairs(candidates) do
			if scripts[script] then
				return ("%s run %s"):format(M.package_manager(ctx.root), script)
			end
		end
		vim.notify(("package.json has no %s script"):format(table.concat(candidates, "/")), vim.log.levels.WARN)
	end
end

--- core.actions provider for package.json projects. Registered by every JS-family language;
--- core.actions merges the filetypes when the same provider name is registered twice.
function M.provider(filetypes)
	return {
		name = "node",
		priority = 20,
		filetypes = vim.deepcopy(filetypes),
		root_markers = { "package.json" },
		actions = {
			run = script_action({ "dev", "start" }),
			build = script_action({ "build" }),
			test = script_action({ "test" }),
		},
		tasks = function(ctx)
			local pm = M.package_manager(ctx.root)
			local names = vim.tbl_keys(M.scripts(ctx.root))
			table.sort(names)
			local tasks = {}
			for _, name in ipairs(names) do
				table.insert(tasks, { name = "script " .. name, cmd = ("%s run %s"):format(pm, name) })
			end
			table.insert(tasks, { name = "install", cmd = pm .. " install" })
			return tasks
		end,
	}
end

return M
