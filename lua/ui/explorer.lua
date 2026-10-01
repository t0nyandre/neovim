local M = {}

function M.setup()
	require("mini.files").setup({
		windows = {
			preview = false,
		},
		options = {
			use_as_default_explorer = true,
		},
	})

	vim.keymap.set("n", "-", function()
		local path = vim.api.nvim_buf_get_name(0)

		if path == "" then
			require("mini.files").open()
		else
			require("mini.files").open(path)
		end
	end, {
		desc = "File Explorer",
	})
end

return M
