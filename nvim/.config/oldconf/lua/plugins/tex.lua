return {
    {
        "lervag/vimtex",
        lazy = false, -- Lazy-loading will disable inverse search
        config = function()
            vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- Disable `K` as it conflicts with LSP hover
            vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_quickfix_open_on_warning = 0
            -- vim.g.vimtex_view_method = "sioyek"
            vim.g.vimtex_view_method = vim.g.is_work_laptop and "skim" or "zathura"

            require("which-key").add({
                { "<localleader>l", group = "+latex(vimtex)" },
            })
        end,
    },
}
