local wezterm = require("wezterm")
return {
	color_scheme = "expressoft",
	window_background_opacity = 0.7,
	color_schemes = {
		["expressoft"] = {
			foreground = "#aa998b",
			background = "#120d09",
			cursor_bg = "#cabeb3",
			cursor_fg = "#241b13",
			cursor_border = "#766454",
			selection_bg = "#766454",
			selection_fg = "#8f7c6d",

			ansi = { "#8f7c6d", "#9c4473", "#739c44", "#9c6d44", "#44739c", "#6d449c", "#449c6d", "#4b3c2e" },
			brights = { "#8f7c6d", "#9c4473", "#739c44", "#9c6d44", "#44739c", "#6d449c", "#449c6d", "#4b3c2e" },
		},
	},
	font = wezterm.font("MapleMono NF"),
	enable_tab_bar = false,
	font_size = 16,
}
