local node = require("core.node")

local filetypes = node.js_filetypes

return {
	filetypes = filetypes,
	treesitter = { "javascript", "jsdoc" },

	lsp = {
		vtsls = {},
		-- Only starts in projects that have an eslint config (lspconfig's root_dir check)
		eslint = {},
	},

	formatters = {
		javascript = node.prettier,
		javascriptreact = node.prettier,
	},

	mason = { "vtsls", "eslint-lsp", "prettierd", "prettier" },
	requires = { "node" },

	provider = node.provider(filetypes),
}
