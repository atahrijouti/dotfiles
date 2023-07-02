local M = {}

local wezterm = require("wezterm")
local helpers = require("helpers")

M.run = function(config)
  config.color_scheme = helpers.schemeForAppearance(helpers.getAppearance())

  config.font = wezterm.font("JetBrainsMono Nerd Font")
  config.font_size = 14
  config.line_height = 1.10

  config.audible_bell = "Disabled"

  config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }

  config.enable_scroll_bar = true
  config.hide_tab_bar_if_only_one_tab = true

  config.disable_default_key_bindings = true
  -- config.debug_key_events = true
end

return M
