return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("tokyonight").setup({
                style = "night",
                dim_inactive = true,
                lualine_bold = true,
                transparent = true,
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "main",
                dim_inactive_windows = true,
                styles = {
                    italic = false,
                },
                highlight_groups = {
                    Comment = { italic = true },
                    Conditionals = { italic = true },
                    Keyword = { italic = true },
                    Type = { bold = true, italic = true },
                    PmenuSel = { fg = "base", bg = "rose" },
                    Pmenu = { bg = "highlight_low" },
                },
            })
            -- vim.cmd([[colorscheme rose-pine]])
        end,
    },
}
