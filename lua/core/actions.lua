-- Project actions (run / build / test / ...) with providers ranked by priority.
--
-- Provider shape:
--   {
--     name = "cmake",
--     priority = 50,                         -- higher wins (platformio 100 > cmake 50 > language 10)
--     filetypes = { "c", "cpp" },            -- optional: only for these filetypes
--     root_markers = { "CMakeLists.txt" },   -- optional: only inside such a project; sets ctx.root
--     outermost_root = true,                 -- optional: root is the outermost marker inside the
--                                            -- git repo, not the nearest (nested CMakeLists.txt)
--     actions = {
--       build = "cmake --build build",       -- string: shell command run in the project root
--       run = function(ctx) ... end,         -- function: return a command string, or do it yourself
--     },
--     tasks = function(ctx) return { { name = "lint", cmd = "npm run lint" } } end, -- extra picker entries
--     program = function(ctx) return "/abs/path/to/binary" end, -- optional: what `build` produces
--   }                                                             -- (used by the debugger; nil = cancel)
-- ctx = { buf, file, ft, root }
--
-- <leader>m ("make") dispatches to the best provider:
--   mb build   mr run   mt test   mc configure (compile_commands.json)   mC clean   mp pick task
-- mp lists every action and task of every provider that applies to the current buffer.
-- Providers may add more <leader>m keys (platformio: mu upload, mm monitor).

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
		if provider.outermost_root then
			for _, marker in ipairs(provider.root_markers) do
				root = require("core.util").outermost_root(buf, marker)
				if root then
					break
				end
			end
		else
			root = vim.fs.root(buf, provider.root_markers)
		end
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

--- Build with the best provider that knows its program, then return the program's path.
--- Must be called from a coroutine (nvim-dap evaluates config functions in one).
---@return string|nil program, table|nil ctx
function M.build_program()
	local item
	for _, candidate in ipairs(M.applicable()) do
		local p = candidate.provider
		if p.program and p.actions and p.actions.build then
			item = candidate
			break
		end
	end
	if not item then
		vim.notify("No provider here can build a debuggable program", vim.log.levels.WARN)
		return nil
	end

	local ctx, provider = item.ctx, item.provider
	local cmd = provider.actions.build
	if type(cmd) == "function" then
		cmd = cmd(ctx)
	end
	if type(cmd) ~= "string" then
		return nil
	end

	local co = assert(coroutine.running(), "build_program must run inside a coroutine")
	vim.notify(("%s: building…"):format(provider.name))
	vim.system({ "sh", "-c", cmd }, { cwd = ctx.root, text = true }, function(res)
		vim.schedule(function()
			coroutine.resume(co, res)
		end)
	end)
	local res = coroutine.yield()

	if res.code ~= 0 then
		local output = (res.stdout or "") .. (res.stderr or "")
		vim.fn.setqflist({}, " ", { title = provider.name .. ": build", lines = vim.split(output, "\n") })
		vim.cmd("botright copen")
		vim.notify(("%s: build failed (see quickfix)"):format(provider.name), vim.log.levels.ERROR)
		return nil
	end

	return provider.program(ctx), ctx
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
	local function map(lhs, action, desc)
		vim.keymap.set("n", lhs, function()
			M.exec(action)
		end, { desc = desc })
	end
	map("<leader>mb", "build", "Build")
	map("<leader>mr", "run", "Run")
	map("<leader>mt", "test", "Test")
	map("<leader>mc", "configure", "Configure (compile_commands.json)")
	map("<leader>mC", "clean", "Clean")
	vim.keymap.set("n", "<leader>mp", M.pick, { desc = "Pick task" })
end

return M
