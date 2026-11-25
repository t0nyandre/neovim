return {
	desc = "Fuzzy picker (snacks.picker); also replaces vim.ui.select",

	requires = { "rg" },

	groups = { { "<leader>f", group = "find" } },

	opts = {
		-- Distros ship libsqlite3.so.0 but only the -dev package adds the unversioned name snacks
		-- looks for; point at the soname so frecency/history use SQLite.
		db = { sqlite3_path = vim.fn.has("linux") == 1 and "libsqlite3.so.0" or nil },
	},

	plugins = function(opts)
		local function pick(name, args)
			return function()
				Snacks.picker[name](args)
			end
		end
		return {
			{
				"folke/snacks.nvim",
				priority = 1000,
				lazy = false,
				opts = { picker = vim.tbl_extend("force", { enabled = true }, opts) },
				keys = {
					{ "<leader><space>", pick("smart"), desc = "Smart find files" },
					{ "<leader>/", pick("grep"), desc = "Grep" },
					{ "<leader>ff", pick("files"), desc = "Files" },
					{ "<leader>fg", pick("grep"), desc = "Grep" },
					{ "<leader>fw", pick("grep_word"), desc = "Grep word", mode = { "n", "x" } },
					{ "<leader>fb", pick("buffers"), desc = "Buffers" },
					{ "<leader>fr", pick("recent"), desc = "Recent files" },
					{ "<leader>fh", pick("help"), desc = "Help" },
					{ "<leader>fk", pick("keymaps"), desc = "Keymaps" },
					{ "<leader>fd", pick("diagnostics"), desc = "Diagnostics" },
					{ "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Config files" },
					{ "<leader>f.", pick("resume"), desc = "Resume last picker" },
					{ "<leader>gl", pick("git_log"), desc = "Git log" },
					{ "<leader>gB", pick("git_branches"), desc = "Git branches" },
				},
			},
		}
	end,
}
