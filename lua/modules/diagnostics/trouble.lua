return {
	desc = "Diagnostics / references / quickfix lists (trouble.nvim)",

	opts = {},

	plugins = function(opts)
		return {
			{
				"folke/trouble.nvim",
				cmd = "Trouble",
				opts = opts,
				keys = {
					{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (workspace)" },
					{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
					{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols" },
					{
						"<leader>xl",
						"<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
						desc = "LSP references/defs",
					},
					{ "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Location list" },
					{ "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
				},
			},
		}
	end,
}
