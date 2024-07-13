return {
    {
        "stevearc/conform.nvim",
        dependencies = { "mason.nvim" },
        lazy = true,
        cmd = "ConformInfo",
        keys = {
            "<leader>rf",
            "<leader>rF",
        },
        config = function()
            require("conform").setup({
                notify_on_error = true,
                -- format_on_save = {
                --     timeout_ms = 2000,
                --     lsp_fallback = true,
                -- },
                formatters_by_ft = {
                    lua = { "stylua"},
                    r = { "rprettify" },
                    bib = { "bibtex-tidy" },
                    tex = { "latexindent" },
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
                options = {
                    ignore_errors = true,
                    lang_to_ext = {
                        bash = "sh",
                        julia = "jl",
                        latex = "tex",
                        markdown = "md",
                        python = "py",
                        rust = "rs",
                        r = "r",
                    },
                },
            }
            -- require("conform").formatters.latexindent = {
            --     prepend_args = { "-m", "-l=" .. vim.fn.expand("$HOME/.latexindent.yaml") },
            -- }

            vim.keymap.set({ "n", "v" }, "<leader>rF",
                function() require("conform").format({ formatters = { "injected" } }) end,
                { desc = "Format Injected Langs" })
            vim.keymap.set("n", "<leader>rf", require("conform").format, { desc = "Format File" })
        end,
    },
}
