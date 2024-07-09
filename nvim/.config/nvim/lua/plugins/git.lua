return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
    {
        "NeogitOrg/neogit",
        -- branch = "nightly",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim", -- optional
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
        end,
        keys = {
            { "<leader>gg", ":Neogit<CR>", desc = "Neogit" },
            { "<leader>gd" },
        },
    },
}
