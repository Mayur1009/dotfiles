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
            local notes_path = vim.g.is_work_laptop and "~/Documents/Notes" or "~/work/Notes"
            require("obsidian").setup({
                ui = { enable = false },
                workspaces = {
                    {
                        name = "local",
                        path = notes_path,
                    },
                },
            })
            local builtin = require("telescope.builtin")
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
