return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        ---@module "tokyonight"
        ---@class tokyonight.Config
        opts = {
            style = "night",
            dim_inactive = true,
            lualine_bold = true,
            on_colors = function(colors)
                colors.border = "#ff9e64" --"#565f89"
            end,
            on_highlights = function (highlights, colors)
                highlights.RenderMarkdownCode = {bg = "#192b38"}
            end
        },
    },
}
