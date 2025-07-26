return {
    {
        "jmbuhr/otter.nvim",
        lazy = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            lsp = {
                diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
            },
        },
    },
}
