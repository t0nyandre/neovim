return {
	{
		"mistricky/codesnap.nvim",

		tag = "v2.1.1",

		config = function()
			require("codesnap").setup({
				show_line_number = true,
				show_workspace = true,
				snapshot_config = {
					window = {
						mac_window_bar = false,
						shadow = {
							radius = 20,
							color = "#00000040",
						},
						margin = {
							x = 0,
							y = 0,
						},
						border = {
							width = 1,
							color = "#ffffff30",
						},
						title_config = {
							color = "#ffffff",
							font_family = "Pacifico",
						},
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
			})
		end,
	},
}
