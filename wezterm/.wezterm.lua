-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- config.font = wezterm.font 'JetBrainsMono Nerd Font Mono' -- No need to set since this is already the default.
config.font_size = 16
config.color_scheme = 'IC_Orange_PPL'

-- Window decorations and other chrome
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- Bell settings
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors = {
  visual_bell = '#202020',
}

config.default_prog = { '/usr/bin/fish', '-l' }

-- Finally, return the configuration to wezterm:
return config
