return {

    {
        "stevearc/conform.nvim",
        dependencies = { "mason.nvim" },
        event = { "BufWritePre" },
        cmd = "ConformInfo",
        config = function()
            require("conform").setup({
                notify_on_error = true,
                -- format_on_save = {
                --     timeout_ms = 2000,
                --     lsp_fallback = true,
                -- },
                formatters = {
                    ["markdown-toc"] = {
                        condition = function(_, ctx)
                            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                                if line:find("<!%-%- toc %-%->") then
                                    return true
                                end
                            end
                        end,
                    },
                    ["markdownlint-cli2"] = {
                        condition = function(_, ctx)
                            local diag = vim.tbl_filter(function(d)
                                return d.source == "markdownlint"
                            end, vim.diagnostic.get(ctx.buf))
                            return #diag > 0
                        end,
                    },
                },
                formatters_by_ft = {
                    markdown = { "markdownlint-cli2", "markdown-toc" },
                    lua = { "stylua" },
                    bib = { "bibtex-tidy" },
                    tex = { "latexindent" },
                    sh = { "shfmt" },
                },
            })
        end,
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
    },
}
