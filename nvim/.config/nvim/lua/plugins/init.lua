return {
    {
        'numToStr/Comment.nvim',
        event = { "BufReadPost", "BufNewFile" },
    },
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("which-key").setup()

            -- Document existing key chains
            require("which-key").register({
                ["<leader>f"] = { name = "+[f]iles", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "+[s]earch", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "+[t]oggle", _ = "which_key_ignore" },
                ["<leader>T"] = { name = "+[T]erminal", _ = "which_key_ignore" },
                ["<leader>x"] = { name = "+Trouble", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "+[g]it", _ = "which_key_ignore" },
                ["<leader>gc"] = { name = "+git [c]onfict", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "+[d]ap", _ = "which_key_ignore" },
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
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
