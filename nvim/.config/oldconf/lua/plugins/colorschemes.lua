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
        "catppuccin/nvim",
        lazy = true,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.01,
                },
                integrations = {
                    aerial = true,
                    alpha = true,
                    cmp = true,
                    dashboard = true,
                    flash = true,
                    gitsigns = true,
                    headlines = true,
                    illuminate = true,
                    indent_blankline = { enabled = true },
                    leap = true,
                    lsp_trouble = true,
                    mason = true,
                    markdown = true,
                    mini = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                    navic = { enabled = true, custom_bg = "lualine" },
                    neotest = true,
                    neotree = true,
                    noice = true,
                    notify = true,
                    semantic_tokens = true,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                    which_key = true,
                },
            })
            -- vim.cmd([[colorscheme catppuccin]])
        end,
    },

    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        config = function()
            require("nightfox").setup({
                options = {
                    -- dim_inactive = true,
                    styles = {
                        comments = "italic",
                        conditionals = "italic",
                        types = "italic,bold",
                    },
                },
                groups = {
                    carbonfox = {
                        Visual = { bg = "#182440" }, -- #224747 #421717, #832d2d, #581e1e, #632f39, #182440
                        NormalNC = { bg = "#101010" },
                    },
                },
            })
            -- vim.cmd([[colorscheme carbonfox]])
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

    {
        "dgox16/oldworld.nvim",
        lazy = true,
        config = function()
            require("oldworld").setup({})
            -- vim.cmd([[colorscheme oldworld]])
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        priority = 1000,
        opts = {
            dim_inactive = true,
        },
    },
}
