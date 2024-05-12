return {
    {
        "stevearc/conform.nvim",
        lazy = false,
        config = function()
            require("conform").setup({
                notify_on_error = true,
                -- format_on_save = {
                --     timeout_ms = 2000,
                --     lsp_fallback = true,
                -- },
                formatters_by_ft = {
                    python = { "ruff_format" },
                    r = { "rprettify" },
                    bib = { "bibtex-tidy" },
                    tex = { "latexindent" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    lua = { "stylua" },
                    fish = { "fish_indent" },
                    sh = { "shfmt" },
                    quarto = { "injected" },
                    markdown = { "injected" },
                },
                formatters = {
                    rprettify = {
                        -- Create script `rprettify` in your PATH($HOME/.local/share/nvim/mason/bin/)
                        -- #!/usr/bin/env sh
                        -- R --quiet --no-echo -e "styler::style_file(\"$1\")" 1>/dev/null 2>&1
                        -- cat "$1"
                        inherit = false,
                        stdin = false,
                        command = "rprettify",
                        args = { "$FILENAME" },
                    },
                },
            })
            -- Customize the "injected" formatter
            require("conform").formatters.injected = {
                -- Set the options field
                options = {
                    -- Set to true to ignore errors
                    ignore_errors = true,
                    -- Map of treesitter language to file extension
                    -- A temporary file name with this extension will be generated during formatting
                    -- because some formatters care about the filename.
                    lang_to_ext = {
                        bash = "sh",
                        c_sharp = "cs",
                        elixir = "exs",
                        javascript = "js",
                        julia = "jl",
                        latex = "tex",
                        markdown = "md",
                        python = "py",
                        ruby = "rb",
                        rust = "rs",
                        teal = "tl",
                        r = "r",
                        typescript = "ts",
                    },
                    -- Map of treesitter language to formatters to use
                    -- (defaults to the value from formatters_by_ft)
                    -- lang_to_formatters = {},
                },
            }
            require("conform").formatters.latexindent = {
                prepend_args = { "-m", "-l=" .. vim.fn.expand("$HOME/.latexindent.yaml") },
            }

            vim.keymap.set("n", "<leader>ff", require("conform").format, { desc = "Format File" })
        end,
    },
}
