local wezterm = require("wezterm")

local M = {}

M.decideColorScheme = function(config)
  local appearance = "Dark"

  if wezterm.gui then
    appearance = wezterm.gui.get_appearance()
  end

  if appearance:find("Dark") then
    return "tokyonight_storm"
  else
    config.colors = {
      background = "#F2F3F7"
    }
    return "tokyonight_day"
  end
end

M.togglePadding = function(config)
  config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }
end

return M
