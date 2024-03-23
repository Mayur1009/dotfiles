return {
    "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VimEnter", -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require("which-key").setup()

            -- Document existing key chains
            require("which-key").register({
                ["<leader>c"] = { name = "[C]ode Runner", _ = "which_key_ignore" },
                ["<leader>f"] = { name = "[F]iles", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
            })
        end,
    },

    { -- Autoformat
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                notify_on_error = false,
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
                formatters_by_ft = {
                    r = { "rprettify" },
                    tex = { "latexindent" },
                    bib = { "bibtex-tidy" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    lua = { "stylua" },
                    -- python = { "ruff_format", "isort", "black" },
                    fish = { "fish_indent" },
                    sh = { "shfmt" },
                    quarto = { "injected" },
                    markdown = { "injected" },
                },
                formatters = {
                    rprettify = {
                        -- Create script `rprettify` in your PATH($HOME/.local/share/nvim/mason/bin/)
                        -- #!/usr/bin/env sh
                        -- R --quiet --no-echo -e "styler::style_file(\"$1\")" 1>/dev/null 2>&1
                        -- cat "$1"
                        inherit = false,
                        stdin = false,
                        command = "rprettify",
                        args = { "$FILENAME" },
                    },
                },
            })
            -- Customize the "injected" formatter
            require("conform").formatters.injected = {
                -- Set the options field
                options = {
                    -- Set to true to ignore errors
                    ignore_errors = true,
                    -- Map of treesitter language to file extension
                    -- A temporary file name with this extension will be generated during formatting
                    -- because some formatters care about the filename.
                    lang_to_ext = {
                        bash = "sh",
                        c_sharp = "cs",
                        elixir = "exs",
                        javascript = "js",
                        julia = "jl",
                        latex = "tex",
                        markdown = "md",
                        python = "py",
                        ruby = "rb",
                        rust = "rs",
                        teal = "tl",
                        r = "r",
                        typescript = "ts",
                    },
                    -- Map of treesitter language to formatters to use
                    -- (defaults to the value from formatters_by_ft)
                    -- lang_to_formatters = {},
                },
            }
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("tokyonight").setup({
                style = "night",
            })
            -- vim.cmd([[colorscheme tokyonight]])
        end,
    },

    {
        "navarasu/onedark.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("onedark").setup({
                style = "warmer",
            })
            -- vim.cmd([[colorscheme onedark]])
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        opts = { variant = "main" },
        lazy = false,
        priority = 1000,
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme carbonfox]])
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
    },
    { -- highlight markdown headings and code blocks etc.
        "lukas-reineke/headlines.nvim",
        -- ft = { "markdown", "quarto" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            vim.cmd([[highlight CodeBlock guibg=#111111]])
            require("headlines").setup({
                quarto = {
                    query = vim.treesitter.query.parse(
                        "markdown",
                        [[
                            (fenced_code_block) @codeblock
                        ]]
                    ),
                    codeblock_highlight = "CodeBlock",
                    treesitter_language = "markdown",
                },
                markdown = {
                    query = vim.treesitter.query.parse(
                        "markdown",
                        [[
                            (fenced_code_block) @codeblock
                        ]]
                    ),
                    codeblock_highlight = "CodeBlock",
                },
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = { "icon", "size", "type", "permissions" },
                delete_to_trash = true,
                experimental_watch_for_changes = true,
                view_options = {
                    show_hidden = true,
                },
                keymaps = {
                    ["<C-d>"] = "actions.close",
                    ["cd"] = "actions.cd",
                    ["<C-r>"] = "actions.refresh",
                    ["gt"] = "actions.toggle_trash",
                },
            })
            vim.keymap.set("n", "<leader>e", require("oil").open_float, { desc = "Oil File Explorer" })
        end,
    },
    { -- terminal
        "akinsho/toggleterm.nvim",
        opts = {
            open_mapping = [[<M-/>]],
            direction = "float",
            shell = "fish",
        },
    },
}
