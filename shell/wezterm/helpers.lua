local wezterm = require("wezterm")

local M = {}

M.getAppearance = function()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

M.schemeForAppearance = function(appearance)
  if appearance:find("Dark") then
    return "tokyonight_storm"
  else
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
