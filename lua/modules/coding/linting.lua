local function clear_lint_diagnostics()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return
	end
	for _, names in pairs(lint.linters_by_ft) do
		for _, name in ipairs(names) do
			vim.diagnostic.reset(lint.get_namespace(name))
		end
	end
end

return {
	desc = "Linting (nvim-lint), linters from enabled languages",

	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		-- filetype -> linters, merged over what languages declare
		linters_by_ft = {},
	},

	plugins = function(opts)
		return {
			{
				"mfussenegger/nvim-lint",
				event = { "BufReadPost", "BufNewFile" },
				config = function()
					local lint = require("lint")
					local by_ft = require("core.languages").by_filetype("linters")
					lint.linters_by_ft = vim.tbl_extend("force", by_ft, opts.linters_by_ft)

					vim.api.nvim_create_autocmd(opts.events, {
						group = vim.api.nvim_create_augroup("modules.coding.linting", { clear = true }),
						callback = function()
							if require("core.toggles").get("lint") then
								lint.try_lint()
							end
						end,
					})
				end,
			},
		}
	end,

	setup = function()
		require("core.toggles").register({
			name = "lint",
			key = "l",
			desc = "Linting",
			apply = function(enabled)
				-- Only act if nvim-lint is already loaded; don't force-load it at startup.
				if not package.loaded["lint"] then
					return
				end
				if enabled then
					require("lint").try_lint()
				else
					clear_lint_diagnostics()
				end
			end,
		})
	end,
}
