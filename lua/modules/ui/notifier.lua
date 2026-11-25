return {
	desc = "Notification popups + history (snacks.notifier)",

	opts = { timeout = 3000 },

	plugins = function(opts)
		return {
			{
				"folke/snacks.nvim",
				priority = 1000,
				lazy = false,
				opts = { notifier = vim.tbl_extend("force", { enabled = true }, opts) },
				keys = {
					{
						"<leader>fn",
						function()
							Snacks.notifier.show_history()
						end,
						desc = "Notification history",
					},
					{
						"<leader>un",
						function()
							Snacks.notifier.hide()
						end,
						desc = "Dismiss notifications",
					},
				},
			},
		}
	end,
}
