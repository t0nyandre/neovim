local M = {}

function M.setup()
	-- Language specific customizations go here

	-- Example:
	-- vim.bo.expandtab = true
	-- vim.bo.shiftwidth = 4

	local wk = require("which-key")
	local map = vim.keymap.set

	local opts = {
		buffer = true,
		silent = true,
	}

	map("n", "<leader>cr", "<cmd>!python3 %<CR>", opts)
	map("n", "<leader>ct", "<cmd>!pytest<CR>", opts)
	map("n", "<leader>cv", "<cmd>!source .venv/bin/activate<CR>", opts)

	wk.add({
		{ "<leader>c", group = "Python" },

		{ "<leader>cr", desc = "Run File" },
		{ "<leader>ct", desc = "Run Tests" },
		{ "<leader>cv", desc = "Activate Venv" },
	})
end

return M
