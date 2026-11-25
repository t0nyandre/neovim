return {
	filetypes = { "python" },
	treesitter = { "python" },

	lsp = {
		basedpyright = {
			settings = {
				basedpyright = {
					analysis = { typeCheckingMode = "standard" },
				},
			},
		},
	},

	formatters = { python = { "ruff_organize_imports", "ruff_format" } },
	linters = { python = { "ruff" } },

	mason = { "basedpyright", "ruff" },
	requires = { "python3" },

	provider = {
		actions = {
			run = function(ctx)
				-- Prefer the project's virtualenv if there is one
				local venv = vim.fs.root(ctx.buf, { ".venv" })
				local python = venv and (venv .. "/.venv/bin/python") or "python3"
				return ("%s %s"):format(python, vim.fn.shellescape(ctx.file))
			end,
			test = function(ctx)
				local venv = vim.fs.root(ctx.buf, { ".venv" })
				return venv and (venv .. "/.venv/bin/python -m pytest") or "pytest"
			end,
		},
	},
}
