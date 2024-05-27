return {
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            local ai = require("mini.ai")
            require("mini.ai").setup({
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                },
            })

            require("mini.hipatterns").setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
                },
            })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - gsd'   - [S]urround [D]elete [']quotes
            -- - gsr)'  - [S]urround [R]eplace [)] [']
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
            require("mini.move").setup()
            require("mini.splitjoin").setup()
            require("mini.misc").setup()
            require("mini.comment").setup()
            require("mini.diff").setup()
            require("mini.git").setup()
            require("mini.fuzzy").setup()
            require('mini.jump').setup()
            require("mini.pairs").setup({})
            vim.keymap.set("n", "<leader>tp", function()
                vim.g.minipairs_disable = not vim.g.minipairs_disable
            end, { desc = "[T]oggle auto [p]airs" })

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require("mini.statusline")
            -- set use_icons to true if you have a Nerd Font
            statusline.setup({ use_icons = vim.g.have_nerd_font })

            -- vim.api.nvim_set_hl(0, "nCursor", { link = "MiniStatuslineModeNormal" })
            vim.api.nvim_set_hl(0, "vCursor", { link = "MiniStatuslineModeVisual" })
            vim.api.nvim_set_hl(0, "rCursor", { link = "MiniStatuslineModeReplace" })
            vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20-rCursor,v:vCursor"

            require("mini.tabline").setup({
                tabpage_section = "right",
            })
            vim.api.nvim_set_hl(0, "MiniTablineCurrent", { link = "MiniStatuslineModeNormal" })
            vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { link = "MiniStatuslineModeInsert" })

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return "%2l:%-2v"
            end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
}
