return {
    {
        "folke/twilight.nvim",
        cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
        opts = {
            dimming = {
                alpha = 0.5,
            },
            context = 20,
            expand = {
                "function",
                "method",
                "table",
                "if_statement",
            },
        },
    },

    {
        "folke/zen-mode.nvim",
        cmd = { "ZenMode" },
        opts = {},
    },
}
