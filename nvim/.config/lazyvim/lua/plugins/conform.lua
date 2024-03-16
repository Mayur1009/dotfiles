return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_filetype = {
                r = { "styler" },
                tex = { "latexindent" },
                bib = { "bibtex-tidy" },
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            formatters = {
                injected = {
                    lang_to_ext = {
                        bash = "sh",
                        julia = "jl",
                        latex = "tex",
                        markdown = "md",
                        python = "py",
                        rust = "rs",
                        r = "r",
                    },
                    lang_to_formatters = {},
                },
            },
        },
    },
}
