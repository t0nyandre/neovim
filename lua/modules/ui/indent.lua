return {
	desc = "Indent guides + current scope (snacks.indent / snacks.scope)",

	opts = {
		indent = {},
		scope = {},
	},

	plugins = function(opts)
		return {
			{
				"folke/snacks.nvim",
				priority = 1000,
				lazy = false,
				opts = {
					indent = vim.tbl_extend("force", { enabled = true }, opts.indent),
					scope = vim.tbl_extend("force", { enabled = true }, opts.scope),
				},
			},
		}
	end,
}
