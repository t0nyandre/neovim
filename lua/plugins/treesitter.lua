local registry = require("utils.language_registry")

return {
	"nvim-treesitter/nvim-treesitter",

	build = ":TSUpdate",

	opts = {
		ensure_installed = require("utils.language_registry").collect("treesitter"),

		auto_install = true,

		highlight = {
			enable = true,
		},

		indent = {
			enable = true,
		},
	},

	config = function(_, opts)
		require("nvim-treesitter").setup(opts)
	end,
}
