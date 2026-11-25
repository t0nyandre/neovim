-- Extended a/i text objects: functions (f), arguments (a), quotes (q), brackets (b), ...
return {
	desc = "Extended text objects (mini.ai)",

	opts = { n_lines = 500 },

	plugins = function(opts)
		return {
			{ "nvim-mini/mini.ai", version = false, event = "VeryLazy", opts = opts },
		}
	end,
}
