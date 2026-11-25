-- nvim-treesitter `main` branch: parsers are installed explicitly and highlighting/indent
-- are started per buffer. The tree-sitter CLI (needed to build parsers) comes from mason.

local function install_parsers(parsers)
	if vim.fn.executable("tree-sitter") ~= 1 then
		return false
	end
	require("nvim-treesitter").install(parsers)
	return true
end

return {
	desc = "Treesitter highlighting and indent (nvim-treesitter main)",

	requires = { "cc", "curl", "tar" },
	mason = { "tree-sitter-cli" },

	opts = {
		-- Parsers installed regardless of enabled languages
		ensure_installed = {
			"bash",
			"diff",
			"git_config",
			"gitcommit",
			"gitignore",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"regex",
			"toml",
			"vim",
			"vimdoc",
			"yaml",
		},
		indent = true,
	},

	plugins = function(opts)
		return {
			{
				"nvim-treesitter/nvim-treesitter",
				branch = "main",
				lazy = false,
				build = ":TSUpdate",
				config = function()
					require("nvim-treesitter").setup()

					local parsers = require("core.util").extend_unique(
						vim.deepcopy(opts.ensure_installed),
						require("core.languages").collect("treesitter")
					)

					if not install_parsers(parsers) then
						-- First run: wait for mason to install tree-sitter-cli.
						vim.api.nvim_create_autocmd("User", {
							pattern = "MasonToolsUpdateCompleted",
							once = true,
							callback = function()
								if not install_parsers(parsers) then
									vim.notify(
										"tree-sitter CLI not found; parsers not installed (see :checkhealth nvim-treesitter)",
										vim.log.levels.WARN
									)
								end
							end,
						})
					end

					vim.api.nvim_create_autocmd("FileType", {
						group = vim.api.nvim_create_augroup("modules.coding.treesitter", { clear = true }),
						callback = function(ev)
							local lang = vim.treesitter.language.get_lang(ev.match)
							if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
								return
							end
							if opts.indent and vim.treesitter.query.get(lang, "indents") then
								vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
							end
						end,
					})
				end,
			},
		}
	end,
}
