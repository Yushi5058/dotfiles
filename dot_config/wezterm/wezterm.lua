-- Pull in the wezterm API
local wezterm = require("wezterm")
local theme = wezterm.plugin.require('https://github.com/neapsix/wezterm').main


return {
colors = theme.colors(),
window_frame = theme.window_frame(), -- needed only if using fancy tab bar
font = wezterm.font("MapleMono NF"),
font_size = 16.0,
 }

