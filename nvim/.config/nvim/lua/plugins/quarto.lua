return {
    {
        "quarto-dev/quarto-nvim",
        cond = not vim.g.vscode,
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        ft = { "quarto", "markdown" },
        config = function()
            local quarto = require("quarto")
            quarto.setup({
                codeRunner = {
                    enabled = false,
                },
            })
        end,
        keys = function()
            return {
                { "<localleader>q", desc = "Quarto" },
                { "<localleader>qa", "<cmd>QuartoActivate<CR>", desc = "Activate" },
                { "<localleader>qp", "<cmd>QuartoPreview<CR>", desc = "Preview" },
                { "<localleader>qq", "<cmd>QuartoClosePreview<CR>", desc = "Close" },
                { "<localleader>qd", "<cmd>QuartoDiagnostics<CR>", desc = "Diagnostics" },
                { "<localleader>qe", "<cmd>lua require('otter').export()<CR>", desc = "Export" },
            }
        end,
    },
}
