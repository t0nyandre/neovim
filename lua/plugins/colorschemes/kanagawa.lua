local features = require("config.features")

return {
	"rebelot/kanagawa.nvim",

	priority = 1000,

	lazy = false,

	enabled = function()
		return features.colorscheme == "kanagawa"
	end,

	config = function()
		require("colorschemes.kanagawa").setup()
	end,
}
