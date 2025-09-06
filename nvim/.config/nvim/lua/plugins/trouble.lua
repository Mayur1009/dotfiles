return {
    {
        "folke/trouble.nvim",
        cond = not vim.g.vscode,
        opts = {
            focus = true,
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>lX",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Toggle Diagnostics",
            },
            {
                "<leader>lx",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Toggle Diagnostics cur buf",
            },
            {
                "<leader>ll",
                "<cmd>Trouble lsp toggle focus=false<cr>",
                desc = "Toggle LSP Def/Ref...",
            },
            {
                "<leader>lL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Toggle Loc List",
            },
            {
                "<leader>lq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Toggle Quickfix List",
            },
        },
    },
}
