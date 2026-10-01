local M = {}

function M.setup()
	require("lualine").setup({
		options = {
			theme = "auto",
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = { "filename" },
			lualine_x = { "diagnostics" },
			lualine_y = { "filetype" },
			lualine_z = { "location" },
		},
	})
end

return M
