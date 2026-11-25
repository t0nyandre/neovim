-- Inside a PlatformIO project, <leader>b/r/t use pio (highest priority), plus <leader>e* extras.
return {
	desc = "PlatformIO actions in projects with platformio.ini",

	requires = { "pio" },

	groups = { { "<leader>e", group = "embedded" } },

	setup = function()
		local actions = require("core.actions")

		actions.register({
			name = "platformio",
			priority = 100,
			filetypes = { "c", "cpp" },
			root_markers = { "platformio.ini" },
			actions = {
				build = "pio run",
				run = "pio run --target upload",
				test = "pio test",
				upload = "pio run --target upload",
				monitor = "pio device monitor",
				compiledb = "pio run --target compiledb",
				clean = "pio run --target clean",
			},
		})

		local function map(lhs, action, desc)
			vim.keymap.set("n", lhs, function()
				actions.exec(action)
			end, { desc = desc })
		end
		map("<leader>eb", "build", "Build firmware")
		map("<leader>eu", "upload", "Upload firmware")
		map("<leader>em", "monitor", "Serial monitor")
		map("<leader>ec", "compiledb", "Generate compile DB")
	end,
}
