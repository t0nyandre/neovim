return {
	desc = "Lazygit in a floating terminal (snacks.lazygit)",

	requires = { "lazygit" },

	groups = { { "<leader>g", group = "git" } },

	opts = {},

	plugins = function(opts)
		return {
			{
				"folke/snacks.nvim",
				priority = 1000,
				lazy = false,
				opts = { lazygit = opts },
				keys = {
					{
						"<leader>gg",
						function()
							Snacks.lazygit()
						end,
						desc = "Lazygit",
					},
					{
						"<leader>gf",
						function()
							Snacks.lazygit.log_file()
						end,
						desc = "Lazygit file history",
					},
				},
			},
		}
	end,
}
