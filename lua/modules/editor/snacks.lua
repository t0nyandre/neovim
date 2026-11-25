return {
	desc = "Snacks extras: bigfile, quickfile, vim.ui.input, LSP word references",

	opts = {
		bigfile = {},
		quickfile = {},
		input = {},
		words = {},
	},

	plugins = function(opts)
		local function on(name)
			return vim.tbl_extend("force", { enabled = true }, opts[name])
		end
		return {
			{
				"folke/snacks.nvim",
				priority = 1000,
				lazy = false,
				opts = {
					bigfile = on("bigfile"),
					quickfile = on("quickfile"),
					input = on("input"),
					words = on("words"),
				},
				keys = {
					{
						"]]",
						function()
							Snacks.words.jump(vim.v.count1)
						end,
						desc = "Next reference",
						mode = { "n", "t" },
					},
					{
						"[[",
						function()
							Snacks.words.jump(-vim.v.count1)
						end,
						desc = "Previous reference",
						mode = { "n", "t" },
					},
				},
			},
		}
	end,
}
