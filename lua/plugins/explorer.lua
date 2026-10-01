local features = require("config.features")

return {
	"echasnovski/mini.nvim",

	enabled = function()
		return features.plugins.ui.explorer
	end,

	config = function()
		require("ui.explorer").setup()
	end,
}
