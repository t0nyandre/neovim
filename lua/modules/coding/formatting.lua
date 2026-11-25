return {
	desc = "Formatting (conform.nvim), formatters from enabled languages",

	opts = {
		timeout_ms = 1000,
		-- filetype -> formatters, merged over what languages declare
		formatters_by_ft = {},
	},

	plugins = function(opts)
		return {
			{
				"stevearc/conform.nvim",
				event = "BufWritePre",
				cmd = "ConformInfo",
				keys = {
					{
						"<leader>cf",
						function()
							require("conform").format({ async = true, lsp_format = "fallback" })
						end,
						mode = { "n", "x" },
						desc = "Format",
					},
				},
				opts = function()
					local by_ft = require("core.languages").by_filetype("formatters")
					return {
						formatters_by_ft = vim.tbl_extend("force", by_ft, opts.formatters_by_ft),
						format_on_save = function(buf)
							if not require("core.toggles").get("format_on_save") or vim.b[buf].disable_autoformat then
								return
							end
							return { timeout_ms = opts.timeout_ms, lsp_format = "fallback" }
						end,
					}
				end,
			},
		}
	end,

	setup = function()
		require("core.toggles").register({ name = "format_on_save", key = "f", desc = "Format on save" })
	end,
}
