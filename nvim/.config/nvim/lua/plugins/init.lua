return {
    { "tpope/vim-sleuth" },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require("persistence").setup({})
            vim.keymap.set("n", "<leader>qs", function()
                require("persistence").load()
            end)
            vim.keymap.set("n", "<leader>qS", function()
                require("persistence").select()
            end)
            vim.keymap.set("n", "<leader>ql", function()
                require("persistence").load({ last = true })
            end)
            vim.keymap.set("n", "<leader>qd", function()
                require("persistence").stop()
            end)
        end,
        keys = {
            "<leader>qs",
            "<leader>qS",
            "<leader>ql",
            "<leader>qd",
        },
    },
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
                -- filter = function(mapping)
                --     return mapping.desc and mapping.desc ~= ""
                -- end,
                spec = {
                    { "<leader>u", group = "+[t]oggle" },
                    { "<leader>v", group = "+terminals" },
                    { "<leader>g", group = "+git" },
                    { "<leader>q", group = "+session" },
                    { "<leader>f", group = "+[f]ind and replace" },
                    { "<localleader>f", group = "+run [f]ile" },
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
    -- {
    --     "nvimdev/indentmini.nvim",
    --     event = { "BufReadPost", "BufNewFile" },
    --     config = function()
    --         require("indentmini").setup({})
    --     end,
    -- },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local tsc = require("treesitter-context")
            tsc.setup({
                max_lines = 4,
                min_window_height = 25,
            })
            vim.keymap.set("n", "<leader>ut", tsc.toggle, { desc = "[T]oggle [T]reesitter Context" })
        end,
    },
    {
        "mbbill/undotree",
        event = "VeryLazy",
        cmd = { "UndotreeToggle" },
        config = function()
            vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
        end,
        keys = { "<leader>uu" },
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
                    syncLine = { n = "<localleader>s" },
                    syncLocations = { n = "<localleader>S" },
                },
                prefills = {
                    flags = "--.",
                },
            })
            vim.keymap.set({ "n", "v" }, "<leader>fa", grug.grug_far, { desc = "Find with grug-far in all files" })
            vim.keymap.set({ "n", "v" }, "<leader>ff", function()
                grug.grug_far({
                    prefills = {
                        filesFilter = vim.fn.expand("%"),
                    },
                })
            end, { desc = "Find with grug-far in current file" })
        end,
        keys = {
            "<leader>ff",
            "<leader>fa",
        },
    },
    -- {
    --     "3rd/image.nvim",
    --     config = function()
    --         require("image").setup({
    --             backend = "kitty",
    --             integrations = {
    --                 markdown = {
    --                     filetypes = { "markdown", "quarto" },
    --                 },
    --             },
    --             max_width = 100,
    --             max_height = 15,
    --             max_width_window_percentage = math.huge,
    --             max_height_window_percentage = math.huge,
    --             window_overlap_clear_enabled = true,
    --             editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    --             tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    --         })
    --     end,
    -- },
    {
        "GCBallesteros/jupytext.nvim",
        config = function()
            require("jupytext").setup({
                style = "quarto",
                output_extension = "qmd",
                force_ft = "quarto",
            })
        end,
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        lazy = false,
    },
}
