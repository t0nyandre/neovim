-- Project actions (run / build / test / ...) with providers ranked by priority.
--
-- Provider shape:
--   {
--     name = "cmake",
--     priority = 50,                         -- higher wins (platformio 100 > cmake 50 > language 10)
--     filetypes = { "c", "cpp" },            -- optional: only for these filetypes
--     root_markers = { "CMakeLists.txt" },   -- optional: only inside such a project; sets ctx.root
--     actions = {
--       build = "cmake --build build",       -- string: shell command run in the project root
--       run = function(ctx) ... end,         -- function: return a command string, or do it yourself
--     },
--     tasks = function(ctx) return { { name = "lint", cmd = "npm run lint" } } end, -- extra picker entries
--   }
-- ctx = { buf, file, ft, root }
--
-- <leader>r/b/t dispatch run/build/test to the best provider; <leader>R picks from every
-- action and task of every provider that applies to the current buffer.

local M = {}

local providers = {}

function M.register(provider)
	provider.priority = provider.priority or 10
	local existing = providers[provider.name]
	if existing and existing.filetypes and provider.filetypes then
		require("core.util").extend_unique(existing.filetypes, provider.filetypes)
		return
	end
	providers[provider.name] = provider
end

local function context(provider, buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype
	if provider.filetypes and not vim.tbl_contains(provider.filetypes, ft) then
		return nil
	end
	local file = vim.api.nvim_buf_get_name(buf)
	local root = vim.fn.getcwd()
	if provider.root_markers then
		root = vim.fs.root(buf, provider.root_markers)
		if not root then
			return nil
		end
	end
	return { buf = buf, file = file, ft = ft, root = root }
end

--- Providers applicable to the current buffer, best first.
function M.applicable()
	local result = {}
	for _, provider in pairs(providers) do
		local ctx = context(provider)
		if ctx then
			table.insert(result, { provider = provider, ctx = ctx })
		end
	end
	table.sort(result, function(a, b)
		return a.provider.priority > b.provider.priority
	end)
	return result
end

local function execute(action, ctx, title)
	local cmd = action
	if type(action) == "function" then
		cmd = action(ctx)
	end
	if type(cmd) == "string" then
		require("core.runner").run(cmd, { cwd = ctx.root, title = title })
	end
end

function M.exec(name)
	for _, item in ipairs(M.applicable()) do
		local action = item.provider.actions and item.provider.actions[name]
		if action then
			return execute(action, item.ctx, item.provider.name .. ": " .. name)
		end
	end
	vim.notify(("No '%s' action for this buffer"):format(name), vim.log.levels.WARN)
end

function M.pick()
	local items = {}
	for _, item in ipairs(M.applicable()) do
		local p = item.provider
		local names = vim.tbl_keys(p.actions or {})
		table.sort(names)
		for _, name in ipairs(names) do
			table.insert(items, { label = p.name .. ": " .. name, action = p.actions[name], ctx = item.ctx })
		end
		if p.tasks then
			for _, task in ipairs(p.tasks(item.ctx) or {}) do
				table.insert(items, { label = p.name .. ": " .. task.name, action = task.cmd, ctx = item.ctx })
			end
		end
	end
	if #items == 0 then
		return vim.notify("No tasks for this buffer", vim.log.levels.WARN)
	end
	vim.ui.select(items, {
		prompt = "Tasks",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if choice then
			execute(choice.action, choice.ctx, choice.label)
		end
	end)
end

function M.setup()
	local map = vim.keymap.set
	map("n", "<leader>r", function()
		M.exec("run")
	end, { desc = "Run" })
	map("n", "<leader>b", function()
		M.exec("build")
	end, { desc = "Build" })
	map("n", "<leader>t", function()
		M.exec("test")
	end, { desc = "Test" })
	map("n", "<leader>R", M.pick, { desc = "Pick task" })
end

return M
