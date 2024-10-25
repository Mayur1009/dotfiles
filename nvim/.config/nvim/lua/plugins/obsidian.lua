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
            local local_path = vim.g.is_work_laptop and "~/Documents/General" or "~/work/General"
            local notes_path = vim.g.is_work_laptop and "~/work/UiA/experiments/Notes" or "~/work/UiA/experiments/Notes"
            require("obsidian").setup({
                ui = { enable = false },
                workspaces = {
                    {
                        name = "local",
                        path = local_path,
                    },
                    {
                        name = "notes",
                        path = notes_path,
                    },
                },

            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>nl", function()
                builtin.find_files({ cwd = local_path, hidden = false })
            end, { desc = "Notes Obsidian vault" })
            vim.keymap.set("n", "<leader>nn", function()
                builtin.find_files({ cwd = notes_path, hidden = false })
            end, { desc = "Notes Obsidian vault" })

            require("which-key").add({
                "<leader>n",
                group = "+notes",
            })
        end,
        keys = {
            "<leader>nn",
        },
    },
}
