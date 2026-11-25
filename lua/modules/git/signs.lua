return {
	desc = "Git signs, hunk actions and blame (gitsigns)",

	requires = { "git" },

	groups = { { "<leader>g", group = "git" } },

	opts = {},

	plugins = function(opts)
		return {
			{
				"lewis6991/gitsigns.nvim",
				event = { "BufReadPre", "BufNewFile" },
				opts = vim.tbl_extend("force", opts, {
					on_attach = function(buf)
						local gs = require("gitsigns")
						local function map(mode, lhs, rhs, desc)
							vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
						end

						map("n", "]h", function()
							gs.nav_hunk("next")
						end, "Next hunk")
						map("n", "[h", function()
							gs.nav_hunk("prev")
						end, "Previous hunk")

						map({ "n", "x" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
						map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
						map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
						map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
						map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
						map("n", "<leader>gb", function()
							gs.blame_line({ full = true })
						end, "Blame line")
						map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle line blame")
						map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>", "Inner hunk")
					end,
				}),
			},
		}
	end,
}
