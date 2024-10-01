return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")
                vim.keymap.set("n", "[h", function ()
                    gitsigns.nav_hunk("prev")
                end, { desc = "Previous Githunk", buffer=bufnr })
                vim.keymap.set("n", "]h", function ()
                    gitsigns.nav_hunk("next")
                end, { desc = "Next Githunk" , buffer=bufnr})
            end
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim", -- optional
        },
        keys = {
            "<leader>gg",
            "<leader>gd",
        },
        config = function()
            require("neogit").setup({
                integrations = {
                    diffview = true,
                    telescope = true,
                },
                telescope_sorter = function()
                    return require("telescope").extensions.fzf.native_fzf_sorter()
                end,
                commit_editor = {
                    staged_diff_split_kind = "auto",
                },
            })

            local diffview_open = false
            vim.keymap.set("n", "<leader>gd", function()
                local cmd = diffview_open and ":DiffviewClose" or ":DiffviewOpen"
                diffview_open = not diffview_open
                vim.cmd(cmd)
            end, { desc = "Git Diffview Toggle" })
            vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Neogit" })
            require("which-key").add({
                "<leader>g",
                group = "+[g]it",
            })
        end,
    },
}
