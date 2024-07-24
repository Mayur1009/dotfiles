return {
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    { "rafamadriz/friendly-snippets" },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-path",
            "ray-x/cmp-treesitter",
            "lukas-reineke/cmp-rg",
            { "kdheepak/cmp-latex-symbols" },
            { "jmbuhr/cmp-pandoc-references" },
            { "micangl/cmp-vimtex" },
            { "hrsh7th/cmp-buffer" },
            { "R-nvim/cmp-r" },
            { "onsails/lspkind.nvim" },
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            luasnip.config.setup({
                history = true,
                delete_check_events = "TextChanged",
            })

            require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.filetype_extend("quarto", { "markdown" })
            luasnip.filetype_extend("rmarkdown", { "markdown" })

            vim.keymap.set(
                "n",
                "<leader>rl",
                require("luasnip.loaders").edit_snippet_files,
                { desc = "Luasnip edit snippet" }
            )

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                -- experimental = {
                --     ghost_text = true
                -- },

                mapping = cmp.mapping.preset.insert({
                    ["<Down>"] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i" }),
                    ["<Up>"] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i" }),
                    -- Select the [n]ext item
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end, { "i" }),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    -- Scroll the documentation window [b]ack / [f]orward
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<C-d>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.close()
                        else
                            fallback()
                        end
                    end, { "i" }),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            fallback()
                        end
                    end),
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        show_labelDetails = true,
                        menu = {
                            nvim_lsp = " ",
                            vimtex = " ",
                            cmp_r = "󰟔 ",
                            luasnip = " ",
                            nvim_lsp_signature_help = "[sig]",
                            path = " ",
                            nvim_lsp_document_symbols = "[ds]",
                            latex_symbols = " ",
                            pandoc_references = " ",
                            treesitter = " ",
                            rg = "[rg]",
                            emoji = "😇",
                            buffer = "󰈔",
                            dap = " ",
                        },
                    }),
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 100 },
                    { name = "vimtex", priority = 100 },
                    { name = "cmp_r", priority = 100 },
                    { name = "nvim_lsp_signature_help", priority = 100 },
                    { name = "luasnip", priority = 95 },
                    { name = "nvim_lsp_document_symbols" },
                    { name = "path" },
                    { name = "latex_symbols" },
                    { name = "pandoc_references" },
                    { name = "treesitter", priority = 10 },
                    { name = "rg", keyword_length = 3, priority = 10 },
                }, {
                    { name = "buffer" },
                }),

                view = {
                    entries = {
                        name = "custom",
                        selection_order = "near_cursor",
                    },
                },

                window = { documentation = cmp.config.window.bordered() },
            })
        end,
    },
}
