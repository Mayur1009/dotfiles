return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("which-key").setup({
                preset = "helix",
                delay = 300,
                -- filter = function(mapping)
                --     return mapping.desc and mapping.desc ~= ""
                -- end,
                spec = {
                    { "<leader>g", group = "+git" },
                    { "<leader>u", group = "+toggle" },
                    { "<leader>s", group = "+search" },
                    { "<leader>c", group = "+code" },
                    {"<localleader>d", group = "+DAP"},
                    {"<localleader>l", group = "+latex(vimtex)"},
                }

            })
        end,
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
