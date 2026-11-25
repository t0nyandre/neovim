return {
	desc = "Auto-close brackets and quotes (mini.pairs)",

	opts = {},

	plugins = function(opts)
		return {
			{ "nvim-mini/mini.pairs", version = false, event = "InsertEnter", opts = opts },
		}
	end,
}
