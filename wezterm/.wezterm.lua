local wezterm = require("wezterm")

local is_macos = function()
    return wezterm.target_triple:find("darwin") ~= nil
end

local config = {
    color_scheme = "tokyonight_night",
    font = wezterm.font("JetBrainsMono Nerd Font Mono"),
    font_size = 16,
    line_height = 1.10,
    enable_tab_bar = false,
    default_prog = { is_macos() and "/opt/homebrew/bin/fish" or "fish", "--interactive", "--login" },
    enable_csi_u_key_encoding = true,
    enable_kitty_keyboard = true,
    term = "wezterm",
    window_padding = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 2,
    },
}

return config
