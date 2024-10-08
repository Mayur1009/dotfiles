return {
    {
        "stevearc/oil.nvim",
        event = "VeryLazy",
        -- dependencies = { "nvim-tree/nvim-web-devicons" },
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
            vim.keymap.set("n", "<leader>,", oil.open_float, { desc = "Oil [f]ile [e]xplorer" })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        event = { "BufReadPost", "BufNewFile" },
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                },
            })
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon add" })
            vim.keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Toggle Harpoon  Menu" })
            for i = 1, 8 do
                vim.keymap.set("n", "<leader>" .. i, function()
                    harpoon:list():select(i)
                end, { desc = "Harpoon File " .. i })
            end
        end,
        keys = function()
            local t = {
                "<leader>h",
                "<leader>a",
            }
            for i = 1, 8 do
                table.insert(t, "<leader>" .. i)
            end
            return t
        end,
    },
}
