local wezterm = require("wezterm")


_G.nocase = function(s)
  s = string.gsub(s, "%a", function(c)
    return string.format("[%s%s]", string.lower(c), string.upper(c))
  end)
  return s
end

local M = {}

-- this runs too many times, so only keeping in the code for now
local switchHelixTheme = function (theme)
    wezterm.run_child_process {
        '/opt/homebrew/bin/nu',
        '-l',
        '-c',
        'scripts switch-helix-theme ' .. theme
    }
end

M.decideColorScheme = function(config)
  local appearance = "Dark"

  if wezterm.gui then
    appearance = wezterm.gui.get_appearance()
  end
  -- config.colors = {
  -- background = "#F2F3F7",
  -- }
  -- previously liked themes
  -- return "Windows 10 Light (base16)"
  -- return "Unikitty Light (base16)"
  -- return "Tomorrow" -- ****
  if appearance:find("Dark") then
    config.colors = {
      background = "#1e1f22",
    }
    return "Tomorrow Night Eighties"
  else
    return "jetbrains_cyan_light"
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
