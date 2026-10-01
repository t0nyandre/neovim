local M = {}

function M.is_project()
	local root = vim.fs.find("CMakeLists.txt", {
		upward = true,
		path = vim.api.nvim_buf_get_name(0),
	})

	return #root > 0
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"c",
			"cpp",
		},

		callback = function()
			if not M.is_project() then
				return
			end

			local wk = require("which-key")

			wk.add({
				{ "<leader>m", group = "Cmake" },

				{ "<leader>mc", desc = "Configure" },
				{ "<leader>mb", desc = "Build" },
				{ "<leader>mr", desc = "Run" },
				{ "<leader>mt", desc = "Test" },
			})

			local opts = {
				buffer = true,
				silent = true,
			}

			vim.keymap.set("n", "<leader>mc", "<cmd>!cmake -B build<CR>", opts)
			vim.keymap.set("n", "<leader>mb", "<cmd>!cmake --build build<CR>", opts)
			vim.keymap.set("n", "<leader>mt", "<cmd>!ctest --test-dir build<CR>", opts)
		end,
	})
end

return M
