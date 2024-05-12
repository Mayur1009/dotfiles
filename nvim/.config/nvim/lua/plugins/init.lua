return {
    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VimEnter", -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require("which-key").setup()

            -- Document existing key chains
            require("which-key").register({
                ["<leader>f"] = { name = "+[f]iles", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "+[s]earch", _ = "which_key_ignore" },
                ["<leader>b"] = { name = "+[b]uffer", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "+[t]oggle", _ = "which_key_ignore" },
                ["<leader>T"] = { name = "+[T]erminal", _ = "which_key_ignore" },
                ["<leader>x"] = { name = "+Trouble", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "+[g]it", _ = "which_key_ignore" },
                ["<leader>gc"] = { name = "+git [c]onfict", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "+[d]ap", _ = "which_key_ignore" },
            })
        end,
    },

    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            indent = {
                char = "▎",
            },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
            scope = { enabled = false },
        },
        main = "ibl",
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
        "ThePrimeagen/harpoon",
        event = "VimEnter",
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon add" })
            vim.keymap.set("n", "<leader>th", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Toggle Harpoon  Menu" })
            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon File 1" })
            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon File 2" })
            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon File 3" })
            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon File 4" })
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
