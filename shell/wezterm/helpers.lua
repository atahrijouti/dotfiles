local wezterm = require("wezterm")


_G.nocase = function(s)
  s = string.gsub(s, "%a", function(c)
    return string.format("[%s%s]", string.lower(c), string.upper(c))
  end)
  return s
end

local M = {}

-- this runs too many times, so only keeping in the code for now
local switchHelixTheme = function(theme)
  -- TODO I would like a better way of doing this... also test on linux
  local command = wezterm.target_triple == "aarch64-apple-darwin" and '/opt/homebrew/bin/nu' or 'nu'

  wezterm.run_child_process {
    command,
    '-l',
    '-c',
    'scripts switch-helix-theme ' .. theme
  }
end

-- previous configs which worked
-- config.colors = {
-- background = "#F2F3F7",
-- }
-- previously liked themes
-- return "Windows 10 Light (base16)"
-- return "Unikitty Light (base16)"
-- return "Tomorrow" -- ****
M.decideColorScheme = function(config)
  local appearance = "Dark"

  if wezterm.gui then
    appearance = wezterm.gui.get_appearance()
  end

  if appearance:find("Dark") then
    switchHelixTheme('dark')
    config.colors = {
      background = "#1e1f22",
    }
    return "Tomorrow Night Eighties"
  else
    switchHelixTheme('light')
    return "jetbrains_cyan_light"
  end
end

return M
