return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            style = "night",
            dim_inactive = true,
            on_colors = function(colors)
                colors.border = "#ff9e64" --"#565f89"
            end,
        }
    },
}
