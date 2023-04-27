local wezterm = require "wezterm"

local helpers = require "helpers"

local config = wezterm.config_builder()

config.color_scheme = helpers.scheme_for_appearance(helpers.get_appearance())
config.font = wezterm.font('Source Code Pro', { weight = "Regular" })
config.font_size = 
  wezterm.target_triple == 'x86_64-pc-windows-msvc'
  and 13
  or 14

config.line_height = 1.15

config.audible_bell = "Disabled"


config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

return config
