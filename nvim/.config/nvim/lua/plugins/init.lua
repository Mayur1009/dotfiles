return {
    {                       -- Useful plugin to show you pending keybinds.
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
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- {
    --     "folke/ts-comments.nvim",
    --     opts = {
    --         quarto = "<!-- %s -->",
    --     },
    --     event = "VeryLazy",
    --     enabled = vim.fn.has("nvim-0.10.0") == 1,
    -- },

    {
        "nvimdev/indentmini.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("indentmini").setup({})
            -- vim.api.nvim_set_hl(0, "IndentLine", { link = "IblIndent" })
            -- vim.api.nvim_set_hl(0, "IndentLineCurrent", { link = "IblScope" })
        end,
    },
    {
        "ThePrimeagen/refactoring.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "Refactor" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local refactoring = require("refactoring")
            refactoring.setup({})
            vim.keymap.set({ "n", "x" }, "<leader>cm", function()
                refactoring.select_refactor({})
            end, { desc = "Refactoring Menu" })
            vim.keymap.set("n", "<leader>cd", function()
                require("refactoring").debug.printf({ below = false })
            end, { desc = "Refactoring debug print statement" })
            vim.keymap.set("n", "<leader>cv", function()
                require("refactoring").debug.print_var({})
            end, { desc = "Refactoring print var" })
            vim.keymap.set("n", "<leader>cc", function()
                require("refactoring").debug.cleanup({})
            end, { desc = "Refactoring print cleanup" })
        end,
        keys = {},
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
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
    },
}
