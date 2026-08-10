hs.loadSpoon("AutoClick")

-- Restrict auto-clicking to these apps. Clicks only fire while the window
-- directly under the mouse belongs to one of them. Leave empty to click
-- unconditionally.
spoon.AutoClick.authorizedApps = {
    "Google Chrome",
    "Vampire Survivors",
    "Safari",
}

-- Optional overrides:
-- spoon.AutoClick.clicksPerSecond = 60            -- default is 60
-- spoon.AutoClick.logger.setLogLevel("debug")     -- trace which app is being checked

spoon.AutoClick:bindHotkeys({
    -- Gate on the app under the mouse (strict).
    triggerAutoClick = { { "ctrl", "alt" }, "F9" },
    -- Gate on the frontmost app (for fullscreen apps with no window under the cursor).
    triggerAutoClickFrontmost = { { "ctrl", "alt" }, "F10" },
})
