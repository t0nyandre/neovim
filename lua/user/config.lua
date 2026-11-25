-- Your switches. Everything not mentioned here uses the module/language default (enabled).
--
--   false        -> disable
--   true         -> enable with defaults
--   { ... }      -> enable and override the module's `opts` (see the module file)
--
-- Module names are "<group>.<file>" under lua/modules/. Run :checkhealth core to see them all.
-- Runtime toggles (<leader>u…) are separate and persist in stdpath("state")/toggles.json.

return {
	colorscheme = "kanagawa", -- "kanagawa" | "cyberdream" (see modules/ui/colorscheme.lua)

	languages = {
		lua = true,
		python = true,
		cpp = true,
		javascript = true,
		typescript = true,
		vue = true,
		web = true,
	},

	modules = {
		-- ui
		["ui.colorscheme"] = true,
		["ui.lualine"] = true,
		["ui.explorer"] = true,
		["ui.which_key"] = true,
		["ui.notifier"] = true,
		["ui.indent"] = true,

		-- editor
		["editor.picker"] = true,
		["editor.pairs"] = true,
		["editor.surround"] = true,
		["editor.ai"] = true,
		["editor.todo"] = true,
		["editor.snacks"] = true,

		-- coding
		["coding.lsp"] = true,
		["coding.completion"] = true,
		["coding.formatting"] = true,
		["coding.linting"] = true,
		["coding.treesitter"] = true,
		["coding.mason"] = true,

		-- git / diagnostics
		["git.signs"] = true,
		["git.diffview"] = true,
		["git.lazygit"] = true,
		["diagnostics.trouble"] = true,

		-- debug
		["debug.dap"] = true,

		-- tools
		["tools.cmake"] = true, -- e.g. { build_type = "Release", run = "./build/tank" }
		["tools.platformio"] = true,
		["tools.codesnap"] = true, -- e.g. { save_dir = "~/Pictures/CodeSnaps" } to override WSL auto-detect
	},
}
