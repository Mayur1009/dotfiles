local wezterm = require("wezterm")

local is_macos = function()
    return wezterm.target_triple:find("darwin") ~= nil
end

local config = {
    color_scheme = "tokyonight_night",
    enable_tab_bar = false,
    enable_wayland = false,
    font = wezterm.font("JetBrainsMono Nerd Font"),
    font_size = 16,
    line_height = 1.10,
    window_padding = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2,
    },
}

return config
