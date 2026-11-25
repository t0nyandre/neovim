local node = require("core.node")

local filetypes = node.ts_filetypes

return {
	filetypes = filetypes,
	treesitter = { "typescript", "tsx", "jsdoc" },

	lsp = {
		vtsls = {
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						variableTypes = { enabled = false },
						functionLikeReturnTypes = { enabled = true },
					},
					updateImportsOnFileMove = { enabled = "always" },
				},
				vtsls = { autoUseWorkspaceTsdk = true },
			},
		},
		eslint = {},
	},

	formatters = {
		typescript = node.prettier,
		typescriptreact = node.prettier,
	},

	mason = { "vtsls", "eslint-lsp", "prettierd", "prettier" },
	requires = { "node" },

	provider = node.provider(filetypes),
}
