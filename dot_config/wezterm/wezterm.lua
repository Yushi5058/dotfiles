local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- settings
config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", scale = 1.24, weight = "Medium" },
	{ family = "CaskaydiaCove Nerd Font", scale = 1.2 },
})
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.use_dead_keys = false
config.default_workspace = "main"

config.window_frame = {
	font = wezterm.font({ family = "Noto Sans", weight = "Regular" }),
}

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

return config
