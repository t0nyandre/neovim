return {
	filetypes = { "lua" },
	treesitter = { "lua", "luadoc" },

	lsp = {
		lua_ls = {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim", "Snacks" } },
					workspace = {
						checkThirdParty = false,
						library = { vim.env.VIMRUNTIME },
					},
					hint = { enable = true },
				},
			},
		},
	},

	formatters = { lua = { "stylua" } },

	mason = { "lua-language-server", "stylua" },

	provider = {
		actions = {
			-- Source the current file into the running Neovim
			run = function(ctx)
				vim.cmd.source(vim.fn.fnameescape(ctx.file))
				vim.notify("Sourced " .. vim.fn.fnamemodify(ctx.file, ":~:."))
			end,
		},
	},
}
