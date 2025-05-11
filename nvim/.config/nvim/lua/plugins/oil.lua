return {
    {
        "stevearc/oil.nvim",
        config = function()
            local oil = require("oil")
            oil.setup({
                columns = { "icon", "size", "type", "permissions" },
                delete_to_trash = true,
                watch_for_changes = true,
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
        end,
        keys = {
            {
                "<leader>e",
                function()
                    require("oil").open_float()
                end,
                desc = "Oil [f]ile [e]xplorer",
            },
        }
    },
}
