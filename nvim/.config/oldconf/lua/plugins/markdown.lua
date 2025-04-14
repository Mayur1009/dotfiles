return {
    -- {
    --     "OXY2DEV/markview.nvim",
    --     ft = {"markdown", "quarto"},
    --     dependencies = {
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-tree/nvim-web-devicons"
    --     },
    -- },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        opts = {
            file_types = { "markdown", "quarto" }
        },
        -- "MeanderingProgrammer/render-markdown.nvim",
        -- lazy = true,
        -- dependencies = { "nvim-treesitter/nvim-treesitter" },
        -- ft = { "markdown", "quarto" },
        -- cmd = { "RenderMarkdownToggle" },
        -- opts = {}
        -- config = function()
        --     require("render-markdown").setup({
        --         file_types = { "markdown", "quarto" },
        --         win_options = {
        --             conceallevel = {
        --                 rendered = 2,
        --             },
        --             concealcursor = {
        --                 rendered = ""
        --             }
        --         },
        --
        --     })
        -- end,
    },

    {
        "HakonHarnes/img-clip.nvim",
        ft = { "markdown", "quarto" },
        opts = {
            filetypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
                quarto = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
            },
        },
    },
}
