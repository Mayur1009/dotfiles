return {
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-y>"] = { "accept" },
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                list = {
                    selection = { preselect = false, auto_insert = true },
                },
                documentation = {
                    auto_show = false,
                    window = {
                        border = "single",
                    },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "single",
                    show_documentation = false,
                    treesitter_highlighting = true,
                },
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer", "lazydev" },
                providers = {
                    path = {
                        opts = {
                            show_hidden_files_by_default = true,
                            get_cwd = function(ctx)
                                return vim.fn.getcwd()
                            end,
                        },
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
}
