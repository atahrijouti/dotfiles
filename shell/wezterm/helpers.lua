local wezterm = require("wezterm")

_G.nocase = function(s)
	s = string.gsub(s, "%a", function(c)
		return string.format("[%s%s]", string.lower(c), string.upper(c))
	end)
	return s
end

local M = {}

M.decideColorScheme = function(config)
	local appearance = "Dark"

	if wezterm.gui then
		appearance = wezterm.gui.get_appearance()
	end

	if appearance:find("Dark") then
		config.colors = {
			background = "#24283b"
		}
		return "Ef-Maris-Dark"
	else
		config.colors = {
			background = "#F2F3F7",
		}
		return "Ef-Maris-Light"
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

return M
