return {
    -- "tpope/vim-fugitive", -- Git commands in nvim
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        event = { "BufNewFile", "BufReadPre" },
        opts = {},
    },

    {
        "NeogitOrg/neogit",
        -- branch = "nightly",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = function()
            require("neogit").setup({ integrations = {
                diffview = true,
            } })

            local diffview_open = false
            vim.keymap.set("n", "<leader>gd", function()
                local cmd = diffview_open and ":DiffviewClose" or ":DiffviewOpen"
                diffview_open = not diffview_open
                vim.cmd(cmd)
            end, { desc = "Git Diffview Toggle" })
        end,
        keys = {
            { "<leader>gg", ":Neogit<CR>", desc = "Neogit" },
            { "<leader>gd" },
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
