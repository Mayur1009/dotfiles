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
            },
            { "kdheepak/cmp-latex-symbols" },
            { "jmbuhr/cmp-pandoc-references" },
            { "micangl/cmp-vimtex" },
            { "rcarriga/cmp-dap" },
            "rafamadriz/friendly-snippets",
        },

        version = "v0.*",
        opts = {
            keymap = {
                preset = "default",
                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
                ["<Tab>"] = { "accept", "fallback" },
                ["<S-Tab>"] = {},
                ['<C-b>'] = {},
                ['<C-f>'] = {},
                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    require("luasnip").jump(direction)
                end,
            },
            sources = {
                compat = {
                    "vimtex",
                    "latex_symbols",
                    "pandoc_references",
                    "dap"
                },
                default = {
                    "lsp",
                    "path",
                    "luasnip",
                    "buffer",
                    "lazydev",
                },

                providers = {
                    lsp = { fallback_for = { "lazydev" } },
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
                    dap = {
                        name = "dap",
                        module = "blink.compat.source",
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
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
                        align_to_component = "none",
                    },
                },
                documentation = {
                    auto_show = true,
                    window = {
                        border = "rounded",
                    },
                },
                ghost_text = {
                    enabled = true,
                },
            },
        },
        opts_extend = { "sources.completion.enabled_providers", "sources.compat", "sources.default" },
    },
}
