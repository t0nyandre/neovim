return {
	desc = "Highlight and search TODO/FIXME/NOTE comments (todo-comments)",

	opts = {},

	plugins = function(opts)
		return {
			{
				"folke/todo-comments.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				event = { "BufReadPost", "BufNewFile" },
				opts = opts,
				keys = {
					{
						"]t",
						function()
							require("todo-comments").jump_next()
						end,
						desc = "Next todo",
					},
					{
						"[t",
						function()
							require("todo-comments").jump_prev()
						end,
						desc = "Previous todo",
					},
					{
						"<leader>ft",
						function()
							if require("core.modules").is_enabled("editor.picker") then
								Snacks.picker.todo_comments()
							else
								vim.cmd("TodoQuickFix")
							end
						end,
						desc = "Todos",
					},
				},
			},
		}
	end,
}
