return {
    {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {
            impersonate_nvim_cmp = true,
        },
    },
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    { "rafamadriz/friendly-snippets" },
                },
                config = function()
                    local luasnip = require("luasnip")
                    luasnip.config.setup({
                        history = true,
                        delete_check_events = "TextChanged",
                    })

                    require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
                    require("luasnip.loaders.from_vscode").lazy_load({
                        paths = { vim.fn.stdpath("config") .. "/snips" },
                    })
                    require("luasnip.loaders.from_vscode").lazy_load()
                    luasnip.filetype_extend("quarto", { "markdown" })
                    luasnip.filetype_extend("rmarkdown", { "markdown" })
                    vim.keymap.set(
                        "n",
                        "<leader>sl",
                        require("luasnip.loaders").edit_snippet_files,
                        { desc = "Luasnip edit snippet" }
                    )
                end,
            },
            { "kdheepak/cmp-latex-symbols" },
            { "jmbuhr/cmp-pandoc-references" },
            { "micangl/cmp-vimtex" },
            "giuxtaposition/blink-cmp-copilot",
            -- { "rcarriga/cmp-dap" },
            "rafamadriz/friendly-snippets",
        },

        version = "v0.*",
        opts = {
            keymap = {
                preset = "default",
                ["<C-l>"] = {
                    "snippet_forward",
                    function(cmp)
                        cmp.show({ providers = { "snippets" } })
                    end,
                    "fallback",
                },
                ["<C-h>"] = { "snippet_backward", "fallback" },
                ["<Tab>"] = { "accept", "fallback" },
                ["<S-Tab>"] = {},
                ["<C-b>"] = {},
                ["<C-f>"] = {},
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = {
                    "lsp",
                    "copilot",
                    "path",
                    "snippets",
                    "buffer",
                    "lazydev",
                    "vimtex",
                    "latex_symbols",
                    "pandoc_references",
                    -- "dap",
                },

                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                    vimtex = {
                        name = "vimtex",
                        module = "blink.compat.source",
                    },
                    latex_symbols = {
                        name = "latex_symbols",
                        module = "blink.compat.source",
                    },
                    pandoc_references = {
                        name = "pandoc_references",
                        module = "blink.compat.source",
                    },

                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "single",
                },
            },
            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                        align_to = "kind_icon",
                    },
                },
                documentation = {
                    auto_show = false,
                    window = {
                        border = "single",
                    },
                },
            },
        },
        opts_extend = { "sources.completion.enabled_providers", "sources.compat", "sources.default" },
    },
}
