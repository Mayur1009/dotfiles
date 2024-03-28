return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-y>",
                        accept_word = "<M-w>",
                        accept_line = "<M-l>",
                        next = "<M-n>",
                        prev = "<M-p>",
                        dismiss = "<M-d>",
                    },
                },
                panel = {
                    layout = {
                        position = "right",
                        ratio = 0.4,
                    },
                },
            })

            -- local cmp = require(cmp)
            -- cmp.event:on("menu_opened", function()
            --     vim.b.copilot_suggestion_hidden = true
            -- end)
            -- cmp.event:on("menu_closed", function()
            --     vim.b.copilot_suggestion_hidden = false
            -- end)
        end,
    },
}
