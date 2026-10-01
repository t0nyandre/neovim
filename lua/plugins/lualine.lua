local features = require("config.features")

return {
	"nvim-lualine/lualine.nvim",

	enabled = function()
		return features.plugins.ui.lualine
	end,

	config = function()
		require("ui.lualine").setup()
	end,
}
