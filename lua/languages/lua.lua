local M = {}

function M.setup()
	local map = vim.keymap.set

	local opts = {
		buffer = true,
		silent = true,
	}
	local wk = require("which-key")

	map("n", "<leader>cs", "<cmd>source %<CR>", opts)
	map("n", "<leader>cr", "<cmd>source $MYVIMRC<CR>", opts)

	wk.add({
		{ "<leader>c", group = "Lua" },

		{ "<leader>cs", desc = "Source File" },
		{ "<leader>cr", desc = "Reload Config" },
	})
end

return M
