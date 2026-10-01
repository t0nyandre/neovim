return {
	colorscheme = "kanagawa",
	plugins = {
		ui = {
			explorer = true,
			lualine = true,
		},
	},
	_defaults = {
		treesitter = {
			"lua",
			"vim",
			"vimdoc",

			"bash",

			"json",
			"yaml",
			"toml",

			"markdown",
			"markdown_inline",

			"git_config",
			"gitcommit",
			"gitignore",
		},
	},
	tools = {
		platformio = true,
		cmake = true,
		codesnap = true,
	},
	python = {
		enabled = true,
		filetypes = { "python" },
		treesitter = { "python" },
		lsp = { "basedpyright" },
		lsp_config = {
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "standard",
					},
				},
			},
		},
		formatter = { "ruff_format" },
		linter = { "ruff" },
		mason = {
			"basedpyright",
			"ruff",
		},
	},
	cpp = {
		enabled = true,
		filetypes = {
			"c",
			"cpp",
			"h",
			"hpp",
		},
		treesitter = {
			"c",
			"cpp",
		},
		lsp = { "clangd" },
		lsp_config = {
			clangd = {
				cmd = {
					"clangd",
					"--compile-commands-dir=build",
				},
			},
		},
		formatter = { "clang_format" },
		linter = { "cpplint" },
		mason = {
			"clangd",
			"clang-format",
			"cpplint",
		},
	},
	lua = {
		enabled = true,
		filetypes = { "lua" },
		treesitter = { "lua" },
		lsp = { "lua_ls" },
		lsp_config = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		},
		formatter = { "stylua" },
		linter = {},
		mason = {
			"lua-language-server",
			"stylua",
		},
	},
}
