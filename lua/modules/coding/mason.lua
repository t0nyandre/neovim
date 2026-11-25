return {
	desc = "Mason: installs LSPs, formatters, linters and CLIs requested by languages/modules",

	opts = {
		-- Extra mason packages to install on top of what languages and modules request
		ensure_installed = {},
		run_on_start = true,
	},

	plugins = function(opts)
		return {
			{
				"mason-org/mason.nvim",
				-- Not lazy: mason prepends its bin dir to PATH, which LSP servers need at startup.
				lazy = false,
				cmd = "Mason",
				keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" } },
				opts = {},
			},
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				dependencies = { "mason-org/mason.nvim" },
				lazy = false,
				opts = function()
					local util = require("core.util")
					local packages = vim.deepcopy(opts.ensure_installed)
					util.extend_unique(packages, require("core.modules").collect("mason"))
					util.extend_unique(packages, require("core.languages").collect("mason"))
					return {
						ensure_installed = packages,
						run_on_start = opts.run_on_start,
					}
				end,
			},
		}
	end,
}
