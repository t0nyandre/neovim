return {
	desc = "File explorer (mini.files), opened with -",

	opts = {
		windows = { preview = false },
		options = { use_as_default_explorer = true },
	},

	init = function(opts)
		if opts.options.use_as_default_explorer then
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end
	end,

	plugins = function(opts)
		return {
			{
				"nvim-mini/mini.files",
				version = false,
				-- Not lazy, so `nvim <dir>` opens in mini.files
				lazy = false,
				opts = opts,
				keys = {
					{
						"-",
						function()
							local path = vim.api.nvim_buf_get_name(0)
							require("mini.files").open(path ~= "" and vim.uv.fs_stat(path) and path or nil)
						end,
						desc = "File explorer",
					},
				},
			},
		}
	end,
}
