local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.run = function(config)
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  end

  return config
end

return M
