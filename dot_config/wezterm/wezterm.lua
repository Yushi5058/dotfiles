local wezterm = require("wezterm")
return {
	color_scheme = "expressoft",
	color_schemes = {
		["expressoft"] = {
			foreground = "#aa998b",
			background = "#120d09",
			cursor_bg = "#cabeb3",
			cursor_border = "#766454",
			cursor_fg = "#241b13",
			selection_bg = "#766454",
			selection_fg = "#8f7c6d",

			ansi = { "#120d09", "#9c4473", "#739c44", "#9c6d44", "#44739c", "#6d449c", "#449c6d", "#4b3c2e" },
			brights = {  "#120d09", "#9c4473", "#739c44", "#9c6d44", "#44739c", "#6d449c", "#449c6d", "#4b3c2e"},
		},
	},
	font = wezterm.font("MapleMono NF"),
	enable_tab_bar = false,
	font_size = 20,
	line_height = 1.5,
}
