return {
	desc = "Diff and file history views (diffview.nvim)",

	requires = { "git" },

	groups = { { "<leader>g", group = "git" } },

	opts = {},

	plugins = function(opts)
		return {
			{
				"sindrets/diffview.nvim",
				cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
				opts = opts,
				keys = {
					{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff working tree" },
					{ "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close diff" },
					{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
					{ "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history" },
				},
			},
		}
	end,
}
