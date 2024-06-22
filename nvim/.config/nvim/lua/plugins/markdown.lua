return {
    {
        "MeanderingProgrammer/markdown.nvim",
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
                },
                highlights = {
                    code = "CodeBlock",
                }
            })
            vim.api.nvim_set_hl(0, "CodeBlock", { bg = "#000000" })
        end,
    },

    -- {
    --     "tadmccorkle/markdown.nvim",
    --     ft = { "markdown", "quarto" },
    --     opts = {
    --         mappings = {
    --             go_curr_heading = "]n", -- (string|boolean) set cursor to current section heading
    --             go_parent_heading = "]N", -- (string|boolean) set cursor to parent section heading
    --             go_next_heading = "]h", -- (string|boolean) set cursor to next section heading
    --             go_prev_heading = "[h", -- (string|boolean) set cursor to previous section heading
    --         },
    --     },
    -- },
}
