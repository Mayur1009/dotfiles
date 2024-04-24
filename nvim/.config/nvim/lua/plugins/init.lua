return {
    -- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

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

    { -- Autoformat
        "stevearc/conform.nvim",
        lazy = false,
        config = function()
            require("conform").setup({
                notify_on_error = false,
                format_on_save = {
                    timeout_ms = 2000,
                    lsp_fallback = true,
                },
                formatters_by_ft = {
                    python = { "ruff_format" },
                    r = { "rprettify" },
                    bib = { "bibtex-tidy" },
                    tex = { "latexindent" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    lua = { "stylua" },
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
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    styles = {
                        comments = "italic",
                        conditionals = "italic",
                        types = "italic,bold",
                    },
                },
                groups = {
                    carbonfox = {
                        Visual = { bg = "#224747" }, -- #421717, #832d2d, #581e1e, #632f39, #182440
                    },
                },
            })
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
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     opts = {},
    --     keys = {
    --         {
    --             "s",
    --             mode = { "n", "x", "o" },
    --             function()
    --                 require("flash").jump()
    --             end,
    --             desc = "Flash",
    --         },
    --         {
    --             "S",
    --             mode = { "n", "o", "x" },
    --             function()
    --                 require("flash").treesitter()
    --             end,
    --             desc = "Flash Treesitter",
    --         },
    --         {
    --             "r",
    --             mode = "o",
    --             function()
    --                 require("flash").remote()
    --             end,
    --             desc = "Remote Flash",
    --         },
    --         {
    --             "R",
    --             mode = { "o", "x" },
    --             function()
    --                 require("flash").treesitter_search()
    --             end,
    --             desc = "Treesitter Search",
    --         },
    --         {
    --             "<c-s>",
    --             mode = { "c" },
    --             function()
    --                 require("flash").toggle()
    --             end,
    --             desc = "Toggle Flash Search",
    --         },
    --     },
    -- },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            indent = {
                char = "▏",
                tab_char = "▏",
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
            scope = {
                show_end = false,
                highlight = { "Function", "Label" },
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
    { -- highlight markdown headings and code blocks etc.
        "lukas-reineke/headlines.nvim",
        -- ft = { "markdown", "quarto" },
        ft = { "quarto", "markdown", "norg", "rmd", "org" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            vim.cmd([[highlight CodeBlock guibg=#111111]])
            vim.schedule(function()
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
                require("headlines").refresh()
            end)
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
            vim.keymap.set("n", "<leader>fe", require("oil").open_float, { desc = "Oil [f]ile [e]xplorer" })
        end,
    },
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("undotree").setup({
                window = { winblend = 10 },
            })

            vim.keymap.set("n", "<leader>tu", require("undotree").toggle, { desc = "[T]oggle [U]ndo Tree" })
        end,
        keys = { -- load the plugin only when using it's keybinding:
            { "<leader>tu" },
        },
    },
    {
        "NStefan002/speedtyper.nvim",
        cmd = "Speedtyper",
        opts = {
            -- your config
        },
    },
}
