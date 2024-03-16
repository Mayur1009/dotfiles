return {
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "moonfly",
        },
    },
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        opts = {
            style = "night",
            dim_inactive = true,
        },
    },
}
