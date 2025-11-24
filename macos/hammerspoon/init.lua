hs.loadSpoon("ShiftIt")
hs.loadSpoon("AutoClick")

spoon.ShiftIt:bindHotkeys({})

spoon.AutoClick.clicksPerSecond = 60
spoon.AutoClick:bindHotkeys({ triggerAutoClick = { { "ctrl", "alt" }, "F9" } })

local log = hs.logger.new("ATJSpoon", "debug")

local function pointInRect(point, rect)
	return point.x >= rect.x and point.x <= (rect.x + rect.w) and point.y >= rect.y and point.y <= (rect.y + rect.h)
end

local autoClickAuthorizedApps = {
	["Google Chrome"] = true,
	["Vampire Survivors"] = true,
}

local appUnderMouse = function()
	-- Get the current mouse position
	local mousePos = hs.mouse.getAbsolutePosition()

	-- Get all visible windows
	local windows = hs.window.orderedWindows()

	if #windows == 0 then
		return false
	end

	local win = windows[1]
	local appName = win:application():name()

	if not autoClickAuthorizedApps[appName] then
		log.i("not chrome", win:application():name())
		return false
	end

	local frame = win:frame()
	if pointInRect(mousePos, frame) then
		return true
	end

	return false
end

spoon.AutoClick.condition = appUnderMouse
