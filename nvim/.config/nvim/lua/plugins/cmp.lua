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
                "<leader>sl",
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

                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end, { "i" }),

                    ["<C-g>"] = cmp.mapping(function()
                        if cmp.visible_docs() then
                            cmp.close_docs()
                        else
                            cmp.open_docs()
                        end
                    end, { "i" }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    ["<C-Space>"] = cmp.mapping.complete({}),

                    ["<C-d>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.close()
                        else
                            fallback()
                        end
                    end, { "i" }),

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
                            emoji = "😇",
                            buffer = "󰈔",
                            dap = " ",
                        },
                    }),
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vimtex" },
                    { name = "cmp_r" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                    { name = "nvim_lsp_document_symbols" },
                    { name = "path" },
                    { name = "latex_symbols" },
                    { name = "pandoc_references" },
                }, {
                    { name = "buffer" },
                }),

                view = {
                    docs = { auto_open = false },
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
