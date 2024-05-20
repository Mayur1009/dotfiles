local wezterm = require("wezterm")

local is_macos = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local scheme = wezterm.get_builtin_color_schemes()["rose-pine"]
-- local select_bg = scheme.selection_fg
-- local select_fg = scheme.selection_bg
-- print(select_bg, select_fg)
-- scheme.selection_fg = select_fg
scheme.selection_bg = "#403d52"

local config = {
	color_schemes = {
		["myrosepine"] = scheme,
	},
	color_scheme = "myrosepine",
	font = wezterm.font("Maple Mono NF", { weight = "Medium" }),
	line_height = 1.15,
	enable_tab_bar = false,
	term = "wezterm",
	default_prog = { is_macos() and "/opt/homebrew/bin/fish" or "fish", "--interactive", "--login" },
	enable_kitty_keyboard = true,
	max_fps = 165,
	front_end = "WebGpu",
	window_padding = {
		left = 2,
		right = 2,
		-- top = 2,
		bottom = 0,
	},
	-- force_reverse_video_cursor = true,
	-- debug_key_events = true,
}

return config
