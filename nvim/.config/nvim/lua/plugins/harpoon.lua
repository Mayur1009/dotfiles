return {
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
        end,
        keys = function()
            local harpoon = require("harpoon")
            local t = {
                {
                    "<leader>h",
                    function()
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Harpoon add",
                },
                {
                    "<leader>a",
                    function()
                        harpoon:list():add()
                    end,
                    desc = "Harpoon add",
                },
            }
            for i = 1, 8 do
                table.insert(t, {
                    "<leader>" .. i,
                    function()
                        harpoon:list():select(i)
                    end,
                    desc = "Harpoon File" .. i,
                })
            end
            return t
        end,
    },
}
