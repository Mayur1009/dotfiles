return {
    {
        "mason-org/mason.nvim",
        cond = not vim.g.vscode,
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        cond = not vim.g.vscode,
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(require("lsp").lsp_config),
                automatic_enable = false,
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cond = not vim.g.vscode,
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
        },
        opts = {
            ensure_installed = {
                -- conform
                "stylua",
                "shfmt",
                "markdown-toc",
                "bibtex-tidy",
                "latexindent",

                -- nvim-lint
                "cmakelint",
                "hadolint",
                "markdownlint-cli2",

                -- dap
                "codelldb",

                -- jupytext
                "jupytext",
            },
        },
        config = function(_, opts)
            local mti = require("mason-tool-installer")
            mti.setup(opts)
        end,
    },
}
