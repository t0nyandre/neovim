-- sa = add, sd = delete, sr = replace, sf/sF = find, sh = highlight  (e.g. saiw" / sd" / sr"')
return {
	desc = "Surround text objects (mini.surround)",

	opts = {},

	plugins = function(opts)
		return {
			{ "nvim-mini/mini.surround", version = false, event = "VeryLazy", opts = opts },
		}
	end,
}
