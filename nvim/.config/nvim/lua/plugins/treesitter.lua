local langs = {
    "bash",
    "bibtex",
    "c",
    "cpp",
    "cmake",
    "cuda",
    "diff",
    "dockerfile",
    "git_config",
    "gitcommit",
    "git_rebase",
    "gitignore",
    "gitattributes",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "julia",
    "latex",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "query",
    "regex",
    "ron",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zig",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        opts_extend = { "ensure_installed" },
        config = function()
            local configs = require("nvim-treesitter.configs")

            ---@diagnostic disable-next-line: missing-fields
            configs.setup({
                ensure_installed = langs,
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "latex" },
                    additional_vim_regex_highlighting = { "latex" },
                },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.inner",
                            ["]o"] = "@code_cell.inner" ,
                            ["]j"] = "@jps"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.inner",
                            ["]O"] = "@code_cell.inner"
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.inner",
                            ["[o"] = "@code_cell.inner",
                            ["[j"] = "@jps"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.inner",
                            ["[O"] = "@code_cell.inner"
                        },
                    },
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- NOTE: Defined with mini.ai plugin
                            --
                            -- You can use the capture groups defined in textobjects.scm
                            -- ["af"] = "@function.outer",
                            -- ["if"] = "@function.inner",
                            -- ["ac"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },

                            -- NOTE: Why they dont work with mini.ai?
                            ["io"] = { query = "@code_cell.inner", desc = "in block" },
                            ["ao"] = { query = "@code_cell.outer", desc = "around block" },
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = "rounded",
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["<leader>tf"] = "@function.outer",
                            ["<leader>tc"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local tsc = require("treesitter-context")
            tsc.setup({
                mode = "cursor",
                max_lines = 4,
            })
            Snacks.toggle({
                name = "Treesitter Context",
                get = tsc.enabled,
                set = function(state)
                    if state then
                        tsc.enable()
                    else
                        tsc.disable()
                    end
                end,
            }):map("<leader>ut")
        end,
    },
}
