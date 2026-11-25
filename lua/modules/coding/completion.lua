return {
	desc = "Completion (blink.cmp)",

	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = { "accept", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = { documentation = { auto_show = true } },
		signature = { enabled = true },
	},

	plugins = function(opts)
		return {
			{
				"saghen/blink.cmp",
				version = "1.*",
				-- Not lazy: blink registers LSP capabilities for every server at startup.
				lazy = false,
				opts = opts,
			},
		}
	end,
}
