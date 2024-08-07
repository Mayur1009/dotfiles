return {
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                preset = "helix",
                delay = 300,
                filter = function(mapping)
                    return mapping.desc and mapping.desc ~= ""
                end,
                spec = {
                    { "<leader>t", group = "+[t]oggle" },
                    { "<leader>v", group = "+terminals" },
                    { "<leader>f", group = "find and replace" },
                    { "<localleader>f", group = "+run file" },
                },
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
    {
        "MagicDuck/grug-far.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = "GrugFar",
        config = function()
            local grug = require("grug-far")
            grug.setup({
                transient = true,
                headerMaxWidth = 80,
                keymaps = {
                    close = { n = "q" },
                    historyOpen = { n = "<localleader>h" },
                    syncLine = { n = "<localleader>s"},
                    syncLocations = { n = "<localleader>S"},
                },
                prefills = {
                    flags = "--.",
                },
            })
            vim.keymap.set({ "n", "v" }, "<leader>fa", grug.grug_far, { desc = "Find with grug-far in all files" })
            vim.keymap.set({ "n" , "v"}, "<leader>ff", function ()
                grug.grug_far({
                    prefills = {
                        filesFilter = vim.fn.expand("%")
                    }
                })
            end, {desc = "Find with grug-far in current file"})
        end,
        keys = {
            "<leader>ff",
            "<leader>fa",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "letieu/harpoon-lualine",
        },
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "┃", right = "┃" },
                    section_separators = { left = "", right = "" },
                    always_divide_middle = false,
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                local cur_width = vim.o.laststatus == 3 and vim.o.columns
                                    or vim.api.nvim_win_get_width(0)
                                return cur_width < 100 and str:sub(1, 1) or str
                            end,
                        },
                    },
                    lualine_b = {},
                    lualine_c = {
                        { "filename", path = 1, shorting_target = 100 },
                        {
                            "buffers",
                            symbols = {
                                alternate_file = "# ",
                            },
                        },
                    },
                    lualine_x = {
                        {
                            "harpoon2",
                            _separator = "",
                            no_harpoon = "",
                        },
                        "diagnostics",
                        "diff",
                        "branch",
                        "filetype",
                    },
                    lualine_y = {},
                    lualine_z = {
                        "%2l:%-2v",
                    },
                },
                extensions = { "lazy", "man", "mason", "oil", "quickfix", "trouble" },
            })
        end,
    },
}
