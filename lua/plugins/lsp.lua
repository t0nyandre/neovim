local registry = require("utils.language_registry")

return {
	{
		"mason-org/mason.nvim",

		opts = {},
	},

	{
		"mason-org/mason-lspconfig.nvim",

		dependencies = {
			"mason-org/mason.nvim",
		},

		opts = {
			ensure_installed = registry.collect("lsp"),
		},
	},

	{
		"neovim/nvim-lspconfig",

		config = function()
			local configs = registry.lsp_configs()

			for server, config in pairs(configs) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},
}
