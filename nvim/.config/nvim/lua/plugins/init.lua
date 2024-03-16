return {
    "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        event = { "BufNewFile", "BufReadPre" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VimEnter", -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require("which-key").setup()

            -- Document existing key chains
            require("which-key").register({
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
                ["<leader>f"] = { name = "[F]iles", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
                ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
            })
        end,
    },

    { -- Autoformat
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                r = { "styler" },
                tex = { "latexindent" },
                bib = { "bibtex-tidy" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                lua = { "stylua" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
    },

    { -- You can easily change to a different colorscheme.
        -- Change the name of the colorscheme plugin below, and then
        -- change the command in the config to whatever the name of that colorscheme is
        --
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
        "folke/tokyonight.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        init = function()
            -- Load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            vim.cmd.colorscheme("tokyonight-night")

            -- You can configure highlights by doing something like
            -- vim.cmd.hi("Comment gui=none")
        end,
    },

    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
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
        },
        main = "ibl",
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local tsc = require("treesitter-context")
            tsc.setup({
                max_lines = 3,
            })
            vim.keymap.set("n", "<leader>tt", tsc.toggle, { desc = "[T]oggle [T]reesitter Context" })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")
            harpoon.setup({
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 4,
                },
            })
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():append()
            end, { desc = "Harpoon add file" })

            vim.keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon Menu" })

            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon file 1" })
            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon file 2" })
            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon file 3" })

            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon file 4" })

            vim.keymap.set("n", "<leader>5", function()
                harpoon:list():select(5)
            end, { desc = "Harpoon file 5" })
        end,
        keys = {
            "<leader>a",
            "<leader>h",
            "<leader>1",
            "<leader>2",
            "<leader>3",
            "<leader>4",
            "<leader>5",
        },
    },
    { -- highlight markdown headings and code blocks etc.
        "lukas-reineke/headlines.nvim",
        -- ft = { "markdown", "quarto" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            vim.cmd([[highlight CodeBlock guibg=#25282e]])
            require("headlines").setup({
                -- markdown = {
                --     query = vim.treesitter.query.parse(
                --         "markdown",
                --         [[
                --             (fenced_code_block) @codeblock
                --         ]]
                --     ),
                --     codeblock_highlight = "CodeBlock",
                -- },
                quarto = {
                    query = vim.treesitter.query.parse(
                        "markdown",
                        [[
                            (fenced_code_block) @codeblock
                        ]]
                    ),
                    treesitter_language = "markdown",
                    codeblock_highlight = "CodeBlock",
                },
            })
        end,
    },
}
