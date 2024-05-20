return {
    {
        "stevearc/oil.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local oil = require("oil")
            oil.setup({
                columns = { "icon", "size", "type", "permissions" },
                delete_to_trash = true,
                experimental_watch_for_changes = true,
                view_options = {
                    show_hidden = true,
                },
                keymaps = {
                    ["cd"] = "actions.cd",
                    ["<C-r>"] = "actions.refresh",
                    ["gt"] = "actions.toggle_trash",
                    ["q"] = "actions.close",
                },
            })
            vim.keymap.set("n", "<leader>,", oil.open, { desc = "Oil [f]ile [e]xplorer" })
        end,
    },
}
