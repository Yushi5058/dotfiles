-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = wezterm.plugin.require('https://github.com/neapsix/wezterm').main
config.font = wezterm.font("MapleMono NF")
config.font_size = 16.0

-- and finally, return the configuration to wezterm
return config
