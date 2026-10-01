local M = {}

function M.setup()
	-- Language specific customizations go here

	-- Example:
	-- vim.bo.shiftwidth = 4
	-- vim.bo.commentstring = "// %s"

	local wk = require("which-key")
	local map = vim.keymap.set

	local opts = {
		buffer = true,
		silent = true,
	}

	map("n", "<leader>cb", "<cmd>!cmake --build build<CR>", opts)
	map("n", "<leader>cc", "<cmd>!cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON<CR>", opts)
	map("n", "<leader>cr", "<cmd>!./build/main<CR>", opts)

	wk.add({
		{ "<leader>c", group = "C++" },

		{ "<leader>cb", desc = "Build Project" },
		{ "<leader>cc", desc = "Configure Project" },
		{ "<leader>cr", desc = "Run Project" },
	})
end

return M
