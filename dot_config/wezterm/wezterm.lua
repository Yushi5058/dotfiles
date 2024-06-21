-- Pull in the wezterm API
local wezterm = require("wezterm")
local theme = require('themes/rose_pine').main


return {
    colors = theme.colors(),
    font = wezterm.font("MapleMono NF"),
    enable_tab_bar = false,
    font_size = 20.0,
}
