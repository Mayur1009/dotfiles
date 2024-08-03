return {
    {
        "ThePrimeagen/refactoring.nvim",
        event = { "BufReadPost" },
        cmd = { "Refactor" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local refactoring = require("refactoring")
            refactoring.setup({})
            vim.keymap.set({ "n", "x" }, "<leader>rm", function()
                refactoring.select_refactor({})
            end, { desc = "Refactoring Menu" })
            vim.keymap.set("n", "<leader>rd", function()
                require("refactoring").debug.printf({ below = false })
            end, { desc = "Refactoring debug print statement" })
            vim.keymap.set("n", "<leader>rv", function()
                require("refactoring").debug.print_var({})
            end, { desc = "Refactoring print var" })
            vim.keymap.set("n", "<leader>rc", function()
                require("refactoring").debug.cleanup({})
            end, { desc = "Refactoring print cleanup" })
            require("which-key").add({
                "<leader>r",
                group = "+[r]efactoring",
            })
        end,
        keys = {},
    },
    {
        "jpalardy/vim-slime",
        event = "VeryLazy",
        init = function()
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_target = "tmux"
            vim.g.slime_default_config = {
                socket_name = "default",
                target_pane = "2",
            }
            vim.keymap.set("v", "<M-s>", "<Plug>SlimeRegionSend", { desc = "Slime Region Send" })
            vim.keymap.set({ "n", "i" }, "<M-s><M-s>", "<Plug>SlimeLineSend", { desc = "Slime Line Send" })
            vim.keymap.set("n", "<M-s>", "<Plug>SlimeMotionSend", { desc = "Slime Motion Send" })
            vim.keymap.set("n", "<M-s><CR>", "<Plug>SlimeSendCell", { desc = "Slime Motion Send" })

            vim.fn.sign_define("SlimeCellTop", { linehl = "SlimeCellBoundaryTop" })
            vim.fn.sign_define("SlimeCellBottom", { linehl = "SlimeCellBoundaryBottom" })
            vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP", "BufEnter" }, {
                group = vim.api.nvim_create_augroup("kickstart_slime_cell_block", { clear = true }),
                pattern = {
                    "*.qmd",
                    "*.py",
                    "*.md",
                },
                callback = function(event)
                    -- Taken from https://github.com/Klafyvel/vim-slime-cells
                    local buf = event.buf
                    local cell_delimiter
                    if vim.b.slime_cell_delimiter then
                        cell_delimiter = vim.b.slime_cell_delimiter
                    elseif vim.g.slime_cell_delimiter then
                        cell_delimiter = vim.g.slime_cell_delimiter
                    else
                        return
                    end
                    vim.fn.sign_unplace("slime_cells_top")
                    vim.fn.sign_unplace("slime_cells_bottom")
                    local l = vim.fn.getline(1, "$")
                    vim.fn.map(l, function(key, value)
                        if vim.fn.match(value, cell_delimiter .. "{.*}$") == 0 then
                            vim.fn.sign_place(0, "slime_cells_top", "SlimeCellTop", buf, { lnum = key + 1 })
                        elseif vim.fn.match(value, cell_delimiter .. "$") == 0 then
                            vim.fn.sign_place(0, "slime_cells_bottom", "SlimeCellBottom", buf, { lnum = key + 1 })
                        end
                    end)
                end,
            })
        end,
    },
    {
        "folke/trouble.nvim",
        event = { "BufReadPost", "LspAttach" },
        config = function()
            require("trouble").setup({
                focus = true,
            })
            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Diagnostics" })
            vim.keymap.set(
                "n",
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                { desc = "Toggle Diagnostics cur buf" }
            )
            vim.keymap.set(
                "n",
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                { desc = "Toggle Symbols" }
            )
            vim.keymap.set(
                "n",
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false<cr>",
                { desc = "Toggle LSP Def/Ref..." }
            )
            vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Toggle Loc List" })
            vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Toggle Quickfix List" })
            vim.keymap.set("n", "<leader>xf", require("trouble").focus, { desc = "Focus Trouble" })
            require("which-key").add({
                "<leader>x",
                group = "+Trouble",
            })
        end,

        keys = {
            "<leader>xx",
            "<leader>xX",
            "<leader>xs",
            "<leader>xl",
            "<leader>xL",
            "<leader>xQ",
            "<leader>xf",
        },
    },
}
