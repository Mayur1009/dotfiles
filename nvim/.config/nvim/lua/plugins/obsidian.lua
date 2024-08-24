return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local phd_path = "~/work/UiA/experiments/PhD"
            local local_path = "~/Documents/Obsidian Vault"
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "PhD",
                        path = phd_path,
                    },
                    {
                        name = "local",
                        path = local_path,
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>np", function()
                builtin.find_files({ cwd = phd_path, hidden = false })
            end, { desc = "PhD Obsidian vault" })
            vim.keymap.set("n", "<leader>nl", function()
                builtin.find_files({ cwd = local_path, hidden = false })
            end, { desc = "Local Obsidian vault" })
            require("which-key").add({
                "<leader>n",
                group = "+notes",
            })
        end,
        keys = {
            "<leader>np",
            "<leader>nl",
        },
    },
}
