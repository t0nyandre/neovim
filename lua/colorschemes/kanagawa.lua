local M = {}

function M.setup()
	require("kanagawa").setup({
		transparent = false,
		theme = "wave",
		background = {
			dark = "wave",
			light = "lotus",
		},
	})

	vim.cmd.colorscheme("kanagawa")
end

return M
