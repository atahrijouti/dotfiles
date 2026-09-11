hs.loadSpoon("AutoClick")
-- hs.loadSpoon("ShiftIt")

spoon.AutoClick.authorizedApps = {
    "Google Chrome",
    "Vampire Survivors",
    "Safari",
}

spoon.AutoClick:bindHotkeys({
    triggerAutoClick = { { "ctrl", "alt" }, "F9" },
    triggerAutoClickFrontmost = { { "ctrl", "alt" }, "F10" },
})

-- spoon.ShiftIt:bindHotkeys({})

-- spoon.ShiftIt:setWindowCyclingSizes({ 50, 40, 33.3, 30 }, { 50 })

local MOUSE_BACK    = 3  -- physical "button 4"
local MOUSE_FORWARD = 4  -- physical "button 5"

local function safariNav(event)
  local app = hs.application.frontmostApplication()
  if app:bundleID() ~= "com.apple.Safari" then return false end

  local button = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
  local path
  if button == MOUSE_BACK then
    path = {"History", "Back"}
  elseif button == MOUSE_FORWARD then
    path = {"History", "Forward"}
  else
    return false
  end

  app:selectMenuItem(path)
  return true  -- swallow it so the page never sees the click
end

safariNavTap = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown}, safariNav)
safariNavTap:start()
