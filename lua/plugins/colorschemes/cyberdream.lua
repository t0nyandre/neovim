local features = require("config.features")

return {
	"scottmckendry/cyberdream.nvim",
	priority = 1000,
	lazy = false,
	enabled = function()
		return features.colorscheme == "cyberdream"
	end,
	config = function()
		require("colorschemes.cyberdream").setup()
	end,
}
