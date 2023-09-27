local wezterm = require("wezterm")

local M = {}

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
