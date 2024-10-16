local M = {}

local wezterm = require("wezterm")

M.run = function(config)
  if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    config.font_size = 11
  end

  return config
end

return M
