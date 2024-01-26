local wezterm = require("wezterm")
local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- settings
config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", scale = 1.24, weight = "Medium" },
	{ family = "CaskaydiaCove Nerd Font", scale = 1.2 },
})
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

return config
