local wezterm = require "wezterm"

local helpers = require "helpers"

local config = wezterm.config_builder()

config.color_scheme = helpers.scheme_for_appearance(helpers.get_appearance())
config.font = wezterm.font('FiraCode NF', { weight = 'Regular'})
config.font_size = 14.0
config.line_height = 1.15

config.window_decorations = "RESIZE"
config.window_padding = {
  left = 15,
  right = 15,
  top = 10,
  bottom = 10,
}

return config
