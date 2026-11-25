-- Only the selected colorscheme (user config `colorscheme = "..."`) is installed.
-- To add a scheme, add an entry to opts.schemes (here or in the user config).

return {
	desc = "Colorscheme selected by `colorscheme` in the user config",

	opts = {
		schemes = {
			kanagawa = {
				repo = "rebelot/kanagawa.nvim",
				module = "kanagawa",
				setup = {
					transparent = false,
					theme = "wave",
					background = { dark = "wave", light = "lotus" },
				},
			},
			cyberdream = {
				repo = "scottmckendry/cyberdream.nvim",
				module = "cyberdream",
				setup = { transparent = false, italic_comments = false },
			},
		},
	},

	plugins = function(opts)
		local name = require("core.config").options.colorscheme
		local scheme = opts.schemes[name]
		if not scheme then
			vim.schedule(function()
				vim.notify(
					("Unknown colorscheme '%s' (add it to ui.colorscheme opts.schemes)"):format(name),
					vim.log.levels.WARN
				)
			end)
			return {}
		end
		return {
			{
				scheme.repo,
				lazy = false,
				priority = 1000,
				config = function()
					if scheme.module then
						require(scheme.module).setup(scheme.setup or {})
					end
					vim.cmd.colorscheme(scheme.colorscheme or name)
				end,
			},
		}
	end,
}
