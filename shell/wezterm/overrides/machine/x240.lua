local M = {}

local wezterm = require("wezterm")

M.run = function(config)
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.font_size = 11
  end

  return config
end

return M
