return {

    "tpope/vim-fugitive", -- Git commands in nvim

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        event = { "BufNewFile", "BufReadPre" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            "nvim-telescope/telescope.nvim", -- optional
        },
        config = function()
            require("neogit").setup({ integrations = {
                diffview = true,
            } })
        end,
        keys = {
            { "<leader>gg", ":Neogit<CR>", desc = "Neogit" },
        },
    },

    {
        "akinsho/git-conflict.nvim",
        config = function()
            require("git-conflict").setup({
                default_mappings = false,
            })
        end,
        keys = {
            { "<leader>gco", ":GitConflictChooseOurs<cr>" },
            { "<leader>gct", ":GitConflictChooseTheirs<cr>" },
            { "<leader>gcb", ":GitConflictChooseBoth<cr>" },
            { "<leader>gc0", ":GitConflictChooseNone<cr>" },
            { "]x", ":GitConflictNextConflict<cr>" },
            { "[x", ":GitConflictPrevConflict<cr>" },
        },
    },
}
