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

function nocase(s)
  s = string.gsub(s, "%a", function(c)
    return string.format("[%s%s]", string.lower(c),
      string.upper(c))
  end)
  return s
end

M.openLazyGitdown = function(window, _pane)
  local panes = window:mux_window():active_tab():panes()

  local targetPaneId = nil
  local info = {}
  for _, pane in ipairs(panes) do
    local title = pane:get_title():gsub("C:\\Windows\\system32\\cmd.exe%s+-%s", "")
    local paneId = pane:pane_id()
    if title:match(nocase("lazygit")) then
      targetPaneId = paneId
    end
    table.insert(info, paneId .. " 👉 " .. title)
  end
  wezterm.log_info(info)
  wezterm.log_info(targetPaneId)
end

return M
