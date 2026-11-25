return {
	desc = "Statusline (lualine)",

	opts = {
		options = {
			theme = "auto",
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff" },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "diagnostics" },
			lualine_y = { "filetype" },
			lualine_z = { "location" },
		},
	},

	init = function()
		-- Avoid the default statusline flashing before lualine loads
		vim.o.laststatus = 3
	end,

	plugins = function(opts)
		return {
			{ "nvim-lualine/lualine.nvim", event = "VeryLazy", opts = opts },
		}
	end,
}
