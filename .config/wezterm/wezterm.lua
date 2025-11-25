local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 16
config.font = wezterm.font("Maple Mono", { weight = "Light", stretch = "Normal", style = "Normal" })
config.color_scheme = "rose-pine-moon"
config.enable_tab_bar = false

return config
