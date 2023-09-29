local wezterm = require("wezterm")

local M = {}

M.openLazyGitdown = function(window, _pane)
  wezterm.log_info("----------------------------------")
  local panes = window:mux_window():active_tab():panes()

  local targetPane = nil

  local info = {}
  for _, pane in ipairs(panes) do
    local title = pane:get_title():gsub("C:\\Windows\\system32\\cmd.exe%s+-%s", "")
    local paneId = pane:pane_id()
    if title:match(nocase("lazygit")) then
      targetPane = pane
    end
    table.insert(info, paneId .. " 👉 " .. title)
  end

  if targetPane then
    targetPane:activate()
    targetPane:send_paste("q")
    window:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, targetPane)
    return
  else
    targetPane = _pane:split({ direction = "Bottom" })
    targetPane:send_paste("lazygit" .. "\n")
  end
end

return M
