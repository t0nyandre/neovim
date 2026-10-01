local M = {}

function M.is_project()
	local root = vim.fs.find("platformio.ini", {
		upward = true,
		path = vim.api.nvim_buf_get_name(0),
	})

	return #root > 0
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp" },

		callback = function()
			if not M.is_project() then
				return
			end

			local wk = require("which-key")

			local opts = {
				buffer = true,
				silent = true,
			}

			vim.keymap.set("n", "<leader>eb", "<cmd>!pio run<CR>", opts)
			vim.keymap.set("n", "<leader>eu", "<cmd>!pio run --target upload<CR>", opts)
			vim.keymap.set("n", "<leader>em", "<cmd>!pio device monitor<CR>", opts)
			vim.keymap.set("n", "<leader>ec", "<cmd>!pio run -t compiledb<CR>", opts)

			wk.add({
				{ "<leader>e", group = "Embedded" },

				{ "<leader>eb", desc = "Build Firmware" },
				{ "<leader>eu", desc = "Upload Firmware" },
				{ "<leader>em", desc = "Serial Monitor" },
				{ "<leader>ec", desc = "Generate Compile DB" },
			})
		end,
	})
end

return M
