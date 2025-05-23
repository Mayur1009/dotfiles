return {
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        config = function()
            local ai = require("mini.ai")
            local extra = require("mini.extra")
            ai.setup({
                n_lines = 500,
                custom_textobjects = {
                    -- o = ai.gen_spec.treesitter({
                    --     a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    --     i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    -- }, {}),
                    -- f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    i = extra.gen_ai_spec.indent(),
                    g = extra.gen_ai_spec.buffer(),
                    d = extra.gen_ai_spec.number(),
                    u = ai.gen_spec.function_call(),
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
                },
            })

            require("mini.hipatterns").setup({
                highlighters = {
                    fixme = extra.gen_highlighter.words({ "FIX", "FIXME", "fixme", "Fixme" }, "MiniHipatternsFixme"),
                    warn = extra.gen_highlighter.words({ "WARN", "warn", "Warn" }, "MiniHipatternsHack"),
                    hack = extra.gen_highlighter.words({ "HACK", "hack", "Hack" }, "MiniHipatternsHack"),
                    todo = extra.gen_highlighter.words({ "TODO", "todo", "Todo" }, "MiniHipatternsTodo"),
                    wip = extra.gen_highlighter.words({ "WIP", "wip", "Wip" }, "MiniHipatternsTodo"),
                    note = extra.gen_highlighter.words({ "NOTE", "note", "Note" }, "MiniHipatternsNote"),
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
                },
            })

            require("mini.surround").setup({
                mappings = {
                    add = "gsa", -- Add surrounding in Normal and Visual modes
                    delete = "gsd", -- Delete surrounding
                    find = "gsf", -- Find surrounding (to the right)
                    find_left = "gsF", -- Find surrounding (to the left)
                    highlight = "gsh", -- Highlight surrounding
                    replace = "gsr", -- Replace surrounding
                    update_n_lines = "gsn", -- Update `n_lines`
                },
            })

            require("mini.jump").setup({
                delay = {
                    idle_stop = 10000,
                },
            })

            local MiniStatusline = require("mini.statusline")
            MiniStatusline.setup({})
            require("mini.tabline").setup()
            require("mini.move").setup()
            require("mini.splitjoin").setup() -- gS
            require("mini.misc").setup() -- printing table and stuff
            require("mini.pairs").setup()
            require("mini.icons").setup()
            require("mini.icons").mock_nvim_web_devicons()

            require("mini.files").setup({
                options = {
                    permanent_delete = false,
                    use_as_default_explorer = false,
                    width_focus = 30,
                    width_preview = 30,
                },
                windows = {
                    preview = true,
                },
            })

            vim.keymap.set("n", "<leader>.", function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
            end, { desc = "Mini Files toggle" })

            vim.keymap.set("n", "<leader>up", function()
                vim.g.minipairs_disable = not vim.g.minipairs_disable
            end, { desc = "[T]oggle auto [p]airs" })
        end,
    },
}
