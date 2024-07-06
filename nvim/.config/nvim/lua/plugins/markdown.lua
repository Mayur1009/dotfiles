return {
    {
        "MeanderingProgrammer/markdown.nvim",
        lazy = true,
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "markdown", "quarto" },
        cmd = { "RenderMarkdownToggle" },
        config = function()
            require("render-markdown").setup({
                file_types = { "markdown", "quarto" },
                win_options = {
                    conceallevel = {
                        rendered = 2,
                    },
                    concealcursor = {
                        rendered = ""
                    }
                },
                -- highlights = {
                -- code = "CodeBlock",
                -- }
            })
        end,
    },
}
