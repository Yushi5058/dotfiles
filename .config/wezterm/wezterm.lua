local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 16
config.font = wezterm.font_with_fallback({
	"Maple Mono",
	"FreeSans",
	"Arial",
})
config.color_scheme = "rose-pine-moon"
config.enable_tab_bar = false
config.window_background_opacity = 0.6
config.unicode_version = 14
config.bidi_enabled = true

return config
