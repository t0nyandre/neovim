-- Inside a PlatformIO project, <leader>m* use pio (highest priority):
--   mb build   mr/mu upload   mt test   mc compile_commands.json (pio compiledb)   mC clean
--   mm serial monitor
-- mu and mm exist only in buffers inside a PlatformIO project.
return {
	desc = "PlatformIO actions in projects with platformio.ini",

	requires = { "pio" },

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
				configure = "pio run --target compiledb",
				clean = "pio run --target clean",
			},
		})

		local function attach(buf)
			if vim.b[buf].platformio_keys or not vim.fs.root(buf, { "platformio.ini" }) then
				return
			end
			vim.b[buf].platformio_keys = true
			local function map(lhs, action, desc)
				vim.keymap.set("n", lhs, function()
					actions.exec(action)
				end, { buffer = buf, desc = desc })
			end
			map("<leader>mu", "upload", "Upload firmware")
			map("<leader>mm", "monitor", "Serial monitor")
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("tools.platformio", { clear = true }),
			pattern = { "c", "cpp" },
			callback = function(ev)
				attach(ev.buf)
			end,
		})
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains({ "c", "cpp" }, vim.bo[buf].filetype) then
				attach(buf)
			end
		end
	end,
}
