-- Vue / Nuxt. vue_ls (v3) runs in hybrid mode: it handles template/style, and forwards
-- TypeScript requests to vtsls, which loads @vue/typescript-plugin from mason's
-- vue-language-server package. Works without the typescript language enabled.

local node = require("core.node")

local vue_plugin_path =
	vim.fs.joinpath(vim.fn.stdpath("data"), "mason/packages/vue-language-server/node_modules/@vue/language-server")

local vtsls_filetypes = vim.list_extend(vim.list_extend({ "vue" }, node.js_filetypes), node.ts_filetypes)

return {
	filetypes = { "vue" },
	treesitter = { "vue", "typescript", "javascript", "css", "scss", "html", "jsdoc" },

	lsp = {
		vue_ls = {},
		vtsls = {
			filetypes = vtsls_filetypes,
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vue_plugin_path,
								languages = { "vue" },
								configNamespace = "typescript",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
				},
			},
		},
		eslint = {},
	},

	formatters = { vue = node.prettier },

	mason = { "vue-language-server", "vtsls", "eslint-lsp", "prettierd", "prettier" },
	requires = { "node" },

	provider = node.provider({ "vue" }),
}
