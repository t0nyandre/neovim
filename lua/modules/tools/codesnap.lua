local util = require("core.util")

local resolved_dir = nil

--- Where snapshots go: opts.save_dir if set, else the Windows Pictures folder on WSL,
--- else ~/Pictures. Resolved once, on first use.
local function save_dir(opts)
	if resolved_dir then
		return resolved_dir
	end
	local dir = opts.save_dir and vim.fn.expand(opts.save_dir)
	if not dir and util.is_wsl then
		-- cwd=/mnt/c avoids cmd.exe's "UNC paths are not supported" warning; stdout only.
		local ok, res = pcall(function()
			return vim.system({ "cmd.exe", "/c", "echo %USERPROFILE%" }, { cwd = "/mnt/c", text = true }):wait()
		end)
		local profile = ok and res.code == 0 and vim.trim(res.stdout or "") or ""
		if profile ~= "" then
			local conv = vim.system({ "wslpath", "-u", profile }, { text = true }):wait()
			local unix = vim.trim(conv.stdout or "")
			if conv.code == 0 and unix ~= "" then
				dir = unix .. "/Pictures/" .. opts.subdir
			end
		end
	end
	dir = dir or vim.fn.expand("~/Pictures/" .. opts.subdir)
	vim.fn.mkdir(dir, "p")
	resolved_dir = dir
	return dir
end

return {
	desc = "Code screenshots (codesnap.nvim); visual <leader>ss save, <leader>sc copy",

	enabled = true,

	groups = { { "<leader>s", group = "snapshot", mode = { "n", "x" } } },

	opts = {
		save_dir = nil, -- nil = auto (Windows Pictures on WSL, ~/Pictures elsewhere)
		subdir = "CodeSnaps",
		codesnap = {
			show_line_number = true,
			show_workspace = true,
			snapshot_config = {
				window = {
					mac_window_bar = false,
					shadow = { radius = 20, color = "#00000040" },
					margin = { x = 0, y = 0 },
					border = { width = 1, color = "#ffffff30" },
					title_config = { color = "#ffffff", font_family = "Pacifico" },
				},
				line_number_color = "#495162",
				code_config = {
					font_family = "CaskaydiaCove Nerd Font",
					breadcrumbs = {
						enable = true,
						separator = "/",
						color = "#80848b",
						font_family = "CaskaydiaCove Nerd Font",
					},
				},
				background = "#00000000",
			},
		},
	},

	plugins = function(opts)
		return {
			{
				"mistricky/codesnap.nvim",
				tag = "v2.1.1",
				cmd = { "CodeSnap", "CodeSnapSave" },
				opts = opts.codesnap,
				keys = {
					{
						"<leader>ss",
						function()
							local file = ("%s/snapshot-%s.png"):format(save_dir(opts), os.date("%Y%m%d-%H%M%S"))
							return ":CodeSnapSave " .. vim.fn.fnameescape(file) .. "<CR>"
						end,
						mode = "x",
						expr = true,
						desc = "Save code snapshot",
					},
					{ "<leader>sc", ":CodeSnap<CR>", mode = "x", desc = "Copy code snapshot" },
				},
			},
		}
	end,
}
