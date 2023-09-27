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

  wezterm.log_info(info)
  wezterm.log_info(targetPane and targetPane:pane_id() .. " - ✅" or "🛑")


  if targetPane then
    return
  else
    targetPane = _pane:split({ direction = "Bottom" })
  end

  targetPane:send_paste("lazygit" .. "\n")

  wezterm.log_info("----------------------------------")
end

return M
