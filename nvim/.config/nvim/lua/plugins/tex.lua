return {

    {
        "lervag/vimtex",
        lazy = false, -- lazy-loading will disable inverse search
        config = function()
            vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
            vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
            -- vim.g.vimtex_view_method = "sioyek"
            vim.g.vimtex_view_method = vim.uv.os_uname().sysname == "Darwin" and "skim" or "zathura"
        end,
    },
}
