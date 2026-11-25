local group = vim.api.nvim_create_augroup("core.autocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = group,
	desc = "Equalize splits on resize",
	command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = group,
	desc = "Restore last cursor position",
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		if ft == "gitcommit" or vim.b[ev.buf].last_pos_restored then
			return
		end
		vim.b[ev.buf].last_pos_restored = true
		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
