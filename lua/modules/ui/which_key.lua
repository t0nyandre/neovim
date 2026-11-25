return {
	desc = "Keymap hints (which-key); groups are declared by each module",

	opts = {},

	plugins = function(opts)
		return {
			{
				"folke/which-key.nvim",
				event = "VeryLazy",
				opts = opts,
				config = function(_, o)
					local wk = require("which-key")
					wk.setup(o)
					wk.add({
						{ "<leader>u", group = "toggle" },
						{ "<leader>x", group = "diagnostics" },
					})
					wk.add(require("core.modules").collect("groups"))
				end,
			},
		}
	end,
}
