return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile", "VeryLazy" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
        },
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "cmake",
                "html",
                "lua",
                "markdown",
                "markdown_inline",
                "vim",
                "vimdoc",
                "r",
                "rnoweb",
                "rust",
                "ron",
                "python",
                "json",
                "latex",
                "bibtex",
                "yaml",
                "dot",
                "ninja",
                "rst",
                "toml",
                "hyprlang",
                "git_config",
            },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                disable = { "latex" },
                additional_vim_regex_highlighting = { "latex", "markdown" },
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
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "around function" },
                        ["if"] = { query = "@function.inner", desc = "in function" },
                        ["ac"] = { query = "@class.outer", desc = "around class" },
                        ["ic"] = { query = "@class.inner", desc = "in class" },
                        ["ao"] = { query = "@code_cell.outer", desc = "around code block" },
                        ["io"] = { query = "@code_cell.inner", desc = "in code block" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                        ["]o"] = "@code_cell.inner",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]A"] = "@parameter.inner",
                        ["]O"] = "@code_cell.inner",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                        ["[o"] = "@code_cell.inner",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner",
                        ["[O"] = "@code_cell.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
            vim.filetype.add({
                pattern = {
                    [".*/waybar/config"] = "jsonc",
                    [".*/mako/config"] = "dosini",
                    [".*/kitty/.+%.conf"] = "bash",
                    [".*/hypr/.+%.conf"] = "hyprlang",
                    ["%.env%.[%w_.-]+"] = "sh",
                    ["%.envrc"] = "sh",
                },
            })
        end,
    },
}
