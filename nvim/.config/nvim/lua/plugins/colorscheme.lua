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
            on_colors = function(c)
                c.border = "#ff9e64" --"#565f89"
            end,
            on_highlights = function(hl, _)
                hl.RenderMarkdownCode = { bg = "#192b38" }
            end,
        },
    },
}
