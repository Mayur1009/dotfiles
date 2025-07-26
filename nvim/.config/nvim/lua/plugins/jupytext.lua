return {
    {
        "GCBallesteros/jupytext.nvim",
        config = function()
            require("jupytext").setup({
                style = "quarto",
                output_extension = "qmd",
                force_ft = "quarto",
            })
        end,
        lazy = false,
    },
}
