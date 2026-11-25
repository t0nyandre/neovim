-- Runs shell commands in a reusable bottom terminal split.

local M = {}

local state = { buf = nil, win = nil }

---@param cmd string
---@param opts? { cwd?: string, title?: string }
function M.run(cmd, opts)
	opts = opts or {}

	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_set_current_win(state.win)
	else
		vim.cmd("botright 15split")
		state.win = vim.api.nvim_get_current_win()
	end

	local old = state.buf
	state.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(state.win, state.buf)
	if old and vim.api.nvim_buf_is_valid(old) then
		pcall(vim.api.nvim_buf_delete, old, { force = true })
	end

	vim.fn.jobstart(cmd, { term = true, cwd = opts.cwd })
	vim.b[state.buf].runner_title = opts.title or cmd
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = state.buf, desc = "Close runner" })
	vim.cmd("normal! G")
end

return M
