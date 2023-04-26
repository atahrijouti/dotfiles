local wezterm = require "wezterm"

local module = {}

function module.get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

function module.scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return "tokyonight_storm"
    else
        return "tokyonight_day"
    end
end

return module
