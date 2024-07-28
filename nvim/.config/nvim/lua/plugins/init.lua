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
                    { "<leader>t", group = "+[t]oggle" },
                    { "<leader>v", group = "+terminals" },
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
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            {
                "letieu/harpoon-lualine",
                dependencies = {
                    "ThePrimeagen/harpoon",
                },
            },
        },
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "|", right = "|" },
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
                                return cur_width < 120 and str:sub(1, 1) or str
                            end,
                            color = { gui = "bold" },
                        },
                    },
                    lualine_b = {
                        { "filename", path = 1 },
                    },
                    lualine_c = {
                        {
                            "buffers",
                            symbols = {
                                alternate_file = "# ",
                            },
                        },
                    },
                    lualine_x = { "harpoon2", "searchcount", "selectioncount" },
                    lualine_y = { "diagnostics", "branch", "diff", "filetype" },
                    lualine_z = { "%2l:%-2v" },
                },
                extensions = { "lazy", "man", "mason", "oil", "quickfix", "trouble" },
            })
        end,
    },
}
