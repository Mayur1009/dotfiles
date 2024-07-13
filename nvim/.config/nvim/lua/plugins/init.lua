return {
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("which-key").setup({
                win = {
                    wo = {
                        winblend = 10,
                    },
                },
                delay = 300,
                filter = function(mapping)
                    return mapping.desc and mapping.desc ~= ""
                end,
                spec = {
                    { "<leader>t",      group = "+[t]oggle" },
                    { "<leader>v",      group = "+terminals" },
                    { "<localleader>f", group = "+run file" },
                },
            })
        end,
    },
    {
        "nvimdev/indentmini.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("indentmini").setup({})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local tsc = require("treesitter-context")
            tsc.setup({
                max_lines = 4,
                min_window_height = 25,
            })
            vim.keymap.set("n", "<leader>tt", tsc.toggle, { desc = "[T]oggle [T]reesitter Context" })
        end,
    },
    {
        "mbbill/undotree",
        event = "VeryLazy",
        cmd = { "UndotreeToggle" },
        config = function()
            vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
        end,
        keys = { "<leader>tu" },
    },
}
