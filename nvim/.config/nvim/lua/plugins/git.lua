return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
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
