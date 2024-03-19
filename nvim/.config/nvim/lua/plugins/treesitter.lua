return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile", "VeryLazy" },
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "html",
                "lua",
                "markdown",
                "markdown_inline",
                "vim",
                "vimdoc",
                "r",
                "python",
                "json",
                "latex",
                "bibtex",
                "yaml",
                "dot",
                "ninja",
                "rst",
                "toml",
            },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = { enable = true, additional_vim_regex_highlighting = false },
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
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ib"] = { query = "@code_cell.inner", desc = "in block" },
                        ["ab"] = { query = "@code_cell.outer", desc = "around block" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]o"] = "@block.inner",
                        ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[o"] = "@block.inner",
                        ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                },
            },
        },
        config = function(_, opts)
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup(opts)

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
    },
}
