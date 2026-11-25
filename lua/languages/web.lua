-- CSS / SCSS / HTML / JSON, plus Tailwind. Tailwind only starts when the project has a
-- tailwind config or a tailwindcss dependency (covers @nuxtjs/tailwindcss and Tailwind v4).

local node = require("core.node")

local tailwind_configs = {
	"tailwind.config.js",
	"tailwind.config.cjs",
	"tailwind.config.mjs",
	"tailwind.config.ts",
}

return {
	filetypes = { "css", "scss", "less", "html", "json", "jsonc" },
	treesitter = { "css", "scss", "html", "json" },

	lsp = {
		cssls = {},
		html = {},
		jsonls = function()
			return {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			}
		end,
		tailwindcss = {
			filetypes = {
				"html",
				"css",
				"scss",
				"less",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
			},
			root_dir = function(bufnr, on_dir)
				local root = vim.fs.root(bufnr, tailwind_configs) or vim.fs.root(bufnr, { "package.json" })
				if not root then
					return
				end
				for _, file in ipairs(tailwind_configs) do
					if vim.uv.fs_stat(vim.fs.joinpath(root, file)) then
						return on_dir(root)
					end
				end
				if node.has_dependency(root, "tailwindcss") then
					on_dir(root)
				end
			end,
		},
	},

	formatters = {
		css = node.prettier,
		scss = node.prettier,
		less = node.prettier,
		html = node.prettier,
		json = node.prettier,
		jsonc = node.prettier,
	},

	mason = { "css-lsp", "html-lsp", "json-lsp", "tailwindcss-language-server", "prettierd", "prettier" },
	requires = { "node" },

	plugins = {
		{ "b0o/SchemaStore.nvim", lazy = true, version = false },
	},
}
