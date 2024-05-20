return {
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- If you want to add a bunch of pre-configured snippets,
            --    you can use this plugin to help you. It even has snippets
            --    for various frameworks/libraries/etc. but you will have to
            --    set up the ones that are useful for you.
            "rafamadriz/friendly-snippets",
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-emoji" },
            { "kdheepak/cmp-latex-symbols" },
            { "jmbuhr/cmp-pandoc-references" },
            { "jmbuhr/otter.nvim" },
            { "micangl/cmp-vimtex" },
            { "hrsh7th/cmp-buffer" },
            { "onsails/lspkind.nvim" },
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            luasnip.config.setup({})

            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
            luasnip.filetype_extend("quarto", { "markdown" })
            luasnip.filetype_extend("rmarkdown", { "markdown" })

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                experimental = {
                    ghost_text = true
                },

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
                            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
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
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        menu = {
                            nvim_lsp = " ",
                            otter = "🦦",
                            vimtex = "",
                            dap = " ",
                            luasnip = " ",
                            path = " ",
                            latex_symbols = " ",
                            pandoc_references = " ",
                            emoji = "😇",
                            buffer = "󰈔",
                        },
                    }),
                },

                sources = cmp.config.sources({
                    { name = "otter" },
                    { name = "nvim_lsp" },
                    { name = "vimtex" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "latex_symbols" },
                    { name = "pandoc_references" },
                    { name = "emoji" },
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

                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.recently_used,
                        require("clangd_extensions.cmp_scores"),
                        cmp.config.compare.score,
                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find(".*=$")
                            local _, entry2_under = entry2.completion_item.label:find(".*=$")
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return true
                            elseif entry1_under < entry2_under then
                                return false
                            end
                        end,

                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find("^_+")
                            local _, entry2_under = entry2.completion_item.label:find("^_+")
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        -- cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            })
        end,
    },
}
