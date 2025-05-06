return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                sources = {
                    files = {
                        hidden = true,
                        ignored = true,
                    },
                    grep = {
                        hidden = true,
                    },
                },
            },
            notifier = { enabled = false },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = true,
                left = { "mark", "git" }, -- priority of signs on the left (high to low)
                right = { "sign", "fold" }, -- priority of signs on the right (high to low)
                folds = {
                    open = true, -- show open fold icons
                    git_hl = true, -- use Git Signs hl for fold icons
                },
            },
            words = { enabled = false },
        },
        keys = {
            {
                "<leader><space>",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Smart Find Files",
            },
            {
                "<leader>/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>E",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
            {
                "<leader>fb",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Find Buffers",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Find Config File",
            },
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>fg",
                function()
                    Snacks.picker.git_files()
                end,
                desc = "Find Git Files",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Find Recent Files",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Find/Grep word",
                mode = { "n", "x" },
            },
            {
                "<leader>sa",
                function()
                    Snacks.picker.autocmds()
                end,
                desc = "Autocmds",
            },
            {
                "<leader>sb",
                function()
                    Snacks.picker.lines()
                end,
                desc = "Buffer Lines",
            },
            {
                "<leader>sc",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>sd",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Diagnostics",
            },
            {
                "<leader>sD",
                function()
                    Snacks.picker.diagnostics_buffer()
                end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Help Pages",
            },
            {
                "<leader>sH",
                function()
                    Snacks.picker.highlights()
                end,
                desc = "Highlights",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>sm",
                function()
                    Snacks.picker.marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>sM",
                function()
                    Snacks.picker.man()
                end,
                desc = "Man Pages",
            },
            {
                "<leader>sp",
                function()
                    Snacks.picker.lazy()
                end,
                desc = "Search for Plugin Spec",
            },
            {
                "<leader>sl",
                function()
                    Snacks.picker.loclist()
                end,
                desc = "Location List",
            },
            {
                "<leader>sq",
                function()
                    Snacks.picker.qflist()
                end,
                desc = "Quickfix List",
            },

            {
                "gd",
                function()
                    Snacks.picker.lsp_definitions()
                end,
                desc = "Goto Definition",
            },
            {
                "gD",
                function()
                    Snacks.picker.lsp_declarations()
                end,
                desc = "Goto Declaration",
            },
            {
                "gr",
                function()
                    Snacks.picker.lsp_references()
                end,
                nowait = true,
                desc = "References",
            },
            {
                "gI",
                function()
                    Snacks.picker.lsp_implementations()
                end,
                desc = "Goto Implementation",
            },
            {
                "gy",
                function()
                    Snacks.picker.lsp_type_definitions()
                end,
                desc = "Goto T[y]pe Definition",
            },
            {
                "<leader>ss",
                function()
                    Snacks.picker.lsp_symbols()
                end,
                desc = "LSP Symbols",
            },
            {
                "<leader>sS",
                function()
                    Snacks.picker.lsp_workspace_symbols()
                end,
                desc = "LSP Workspace Symbols",
            },

            {
                "d<Tab>",
                function()
                    Snacks.bufdelete()
                end,
                desc = "Delete Buffer",
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },
}
