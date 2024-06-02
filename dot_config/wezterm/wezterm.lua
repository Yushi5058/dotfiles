-- Pull in the wezterm API
local wezterm = require("wezterm")
local theme = require('themes/rose_pine').main


return {
  colors = theme.colors(),
  window_frame = theme.window_frame(), -- needed only if using fancy tab bar
  font = wezterm.font("MapleMono NF"),
  enable_tab_bar = false,
  font_size = 16.0,
}
