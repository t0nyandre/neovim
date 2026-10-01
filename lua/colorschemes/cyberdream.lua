local M = {}

function M.setup()
	require("cyberdream").setup({
		transparent = false,
		italic = false,
	})

	vim.cmd.colorscheme("cyberdream")
end

return M
