-- Pull in the wezterm API
local wezterm = require("wezterm")
local theme = require('themes/rose_pine').main


return {
  colors = theme.colors(),
  window_frame = theme.window_frame(), -- needed only if using fancy tab bar
  font = wezterm.font("MapleMono NF"),
  enable_tab_bar = false,
  font_size = 16.0,

  -- zen mode functionality
  wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
      local incremental = value:find("+")
      local number_value = tonumber(value)
      if incremental ~= nil then
        while (number_value > 0) do
          window:perform_action(wezterm.action.IncreaseFontSize, pane)
          number_value = number_value - 1
        end
        overrides.enable_tab_bar = false
      elseif number_value < 0 then
        window:perform_action(wezterm.action.ResetFontSize, pane)
        overrides.font_size = nil
        overrides.enable_tab_bar = true
      else
        overrides.font_size = number_value
        overrides.enable_tab_bar = false
      end
    end
    window:set_config_overrides(overrides)
  end)
}
