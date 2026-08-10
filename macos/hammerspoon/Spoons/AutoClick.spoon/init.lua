--- === AutoClick ===
---
--- Autoclicker tool, configurable with clicks per second.
---
--- Two independent triggers, each with its own hotkey and its own on/off state:
---  * "mouse"     - clicks only while the window under the mouse is authorized.
---  * "frontmost" - clicks only while the frontmost app is authorized.
--- When `authorizedApps` is empty, a trigger clicks unconditionally.
---
--- Based on the AutoClick spoon by Carlos Lázaro Costa.
--- Download: [https://github.com/Carleslc/Spoons/raw/master/Spoons/AutoClick.spoon.zip](https://github.com/Carleslc/Spoons/raw/master/Spoons/AutoClick.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata

obj.name = "AutoClick"
obj.version = "2.0"
obj.author = "Carlos Lázaro Costa <lazaro.costa.carles@gmail.com>"
obj.homepage = "https://github.com/Carleslc/"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- AutoClick.logger
--- Variable
--- Logger. Set to "debug" to trace skipped clicks:
--- `spoon.AutoClick.logger.setLogLevel("debug")`.
obj.logger = hs.logger.new("AutoClick", "info")

--- AutoClick.clicksPerSecond
--- Variable
--- Clicks per second. May not work properly if set too high (above ~50).
--- Defaults to 60.
obj.clicksPerSecond = 60

--- AutoClick.authorizedApps
--- Variable
--- Apps in which auto-clicking is allowed. May be an array of names
--- (`{ "Safari", "Google Chrome" }`) or a set (`{ ["Safari"] = true }`).
--- When empty (the default), clicking is unrestricted.
obj.authorizedApps = {}

-- Helpers (module-local, no global namespace pollution)

local function pointInRect(point, rect)
    return point.x >= rect.x and point.x <= (rect.x + rect.w)
        and point.y >= rect.y and point.y <= (rect.y + rect.h)
end

-- Normalize `authorizedApps` (array or set form) into a lookup set + count.
local function toAppSet(apps)
    local set, count = {}, 0
    if type(apps) ~= "table" then
        return set, count
    end
    for key, value in pairs(apps) do
        local name
        if type(key) == "number" and type(value) == "string" then
            name = value -- array form: { "Safari", ... }
        elseif type(key) == "string" and value then
            name = key   -- set form: { ["Safari"] = true }
        end
        if name and not set[name] then
            set[name] = true
            count = count + 1
        end
    end
    return set, count
end

--- AutoClick:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for AutoClick
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for:
---   * triggerAutoClick - Start/Stop clicking, gated on the app under the mouse
---   * triggerAutoClickFrontmost - Start/Stop clicking, gated on the frontmost app
function obj:bindHotkeys(mapping)
    hs.spoons.bindHotkeysToSpec({
        triggerAutoClick = hs.fnutils.partial(self.trigger, self),
        triggerAutoClickFrontmost = hs.fnutils.partial(self.triggerFrontmost, self),
    }, mapping)
    return self
end

--- AutoClick:init()
--- Method
--- Initializes AutoClick
function obj:init()
    self._timers = {} -- one timer per trigger, keyed by label; nil when stopped
    return self
end

--- AutoClick:appUnderMouse()
--- Method
--- Returns the name of the app owning the topmost window under the mouse, or nil.
function obj:appUnderMouse()
    local pos = hs.mouse.getAbsolutePosition()
    -- orderedWindows() is front-to-back, so the first hit is the topmost window.
    for _, win in ipairs(hs.window.orderedWindows()) do
        local ok, frame = pcall(win.frame, win)
        if ok and frame and pointInRect(pos, frame) then
            local app = win:application()
            return app and app:name() or nil
        end
    end
    return nil
end

--- AutoClick:frontmostApp()
--- Method
--- Returns the name of the frontmost (focused) application, or nil.
function obj:frontmostApp()
    local app = hs.application.frontmostApplication()
    return app and app:name() or nil
end

-- Start/stop one independent clicker. `appFor` returns the app name to gate on.
function obj:_toggle(label, appFor)
    if self._timers[label] then
        self._timers[label]:stop()
        self._timers[label] = nil
        self:notify(label .. ": stopped")
        return
    end

    local authorized, count = toAppSet(self.authorizedApps)
    local delayMillis = 1000 / self.clicksPerSecond
    local clickDelayMicros = delayMillis * 1000 / 2
    local interval = delayMillis / 1000 / 2

    self:notify(label .. ": started" .. (count > 0 and " (gated)" or ""))

    self._timers[label] = hs.timer.doWhile(
        function() return self._timers[label] ~= nil end,
        function()
            if count > 0 then
                local app = appFor(self)
                if not (app and authorized[app]) then
                    self.logger.df("%s: '%s' not authorized, skipping", label, tostring(app))
                    return -- skip this tick, keep the timer running
                end
            end
            hs.eventtap.leftClick(hs.mouse.getAbsolutePosition(), clickDelayMicros)
        end,
        interval)
end

--- AutoClick:trigger()
--- Method
--- Start/Stop the mouse-gated clicker (gated on the app under the mouse).
function obj:trigger()
    self:_toggle("mouse", self.appUnderMouse)
end

--- AutoClick:triggerFrontmost()
--- Method
--- Start/Stop the frontmost-gated clicker (gated on the frontmost app).
function obj:triggerFrontmost()
    self:_toggle("frontmost", self.frontmostApp)
end

--- AutoClick:notify(text)
--- Method
--- Shows a short notification titled with the spoon name.
function obj:notify(text)
    self.logger.i(text)
    hs.notify.new({ title = self.name, informativeText = text, withdrawAfter = 2 }):send()
end

return obj
