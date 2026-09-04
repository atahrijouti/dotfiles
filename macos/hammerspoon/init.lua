hs.loadSpoon("AutoClick")
hs.loadSpoon("ShiftIt")

spoon.AutoClick.authorizedApps = {
    "Google Chrome",
    "Vampire Survivors",
    "Safari",
}

spoon.AutoClick:bindHotkeys({
    triggerAutoClick = { { "ctrl", "alt" }, "F9" },
    triggerAutoClickFrontmost = { { "ctrl", "alt" }, "F10" },
})

spoon.ShiftIt:bindHotkeys({})

spoon.ShiftIt:setWindowCyclingSizes({ 50, 40, 33.3, 30 }, { 50 })
