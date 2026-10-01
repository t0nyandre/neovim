local M = {}

function M.setup()
	local save_dir = "/mnt/c/Users/post/Pictures/CodeSnaps"

	vim.keymap.set("x", "<leader>ss", function()
		local filename = string.format("%s/snapshot-%s.png", save_dir, os.date("%d%m%Y-%H%M%S"))

		local cmd = string.format(":CodeSnapSave %s<CR>", filename)

		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "x", false)
	end, {
		silent = true,
		desc = "Save Code Snapshot",
	})
end

return M
