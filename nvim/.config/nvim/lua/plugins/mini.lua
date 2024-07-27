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
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
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
                    fixme = extra.gen_highlighter.words({ "FIXME", "fixme", "Fixme" }, "MiniHipatternsFixme"),
                    hack = extra.gen_highlighter.words({ "HACK", "hack", "Hack" }, "MiniHipatternsHack"),
                    todo = extra.gen_highlighter.words({ "TODO", "todo", "Todo" }, "MiniHipatternsTodo"),
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

            require("mini.move").setup()
            require("mini.splitjoin").setup() -- gS
            require("mini.misc").setup() -- printing table and stuff
            require("mini.pairs").setup()
            require("mini.icons").setup()
            require("mini.icons").mock_nvim_web_devicons()

            vim.keymap.set("n", "<leader>tp", function()
                vim.g.minipairs_disable = not vim.g.minipairs_disable
            end, { desc = "[T]oggle auto [p]airs" })

            -- local statusline = require("mini.statusline")
            -- statusline.setup({ use_icons = vim.g.have_nerd_font })
            --
            -- ---@diagnostic disable-next-line: duplicate-set-field
            -- statusline.section_location = function()
            --     return "%2l:%-2v"
            -- end
        end,
    },
}
