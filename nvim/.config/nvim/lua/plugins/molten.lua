return {
    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    -- clear_in_insert_mode = false,
                    -- download_remote_images = true,
                    only_render_image_at_cursor = true,
                    filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
                },
                neorg = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "norg" },
                },
            },
            max_width = 100,
            max_height = 15,
            max_width_window_percentage = math.huge,
            max_height_window_percentage = math.huge,
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
            editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        },
    },
    {
        "GCBallesteros/jupytext.nvim",
        config = function()
            require("jupytext").setup({
                -- style = "markdown",
                -- output_extension = "md",
                -- force_ft = "markdown",
                style = "quarto",
                output_extension = "qmd",
                force_ft = "quarto",
            })
        end,
    },
    {
        "benlubas/molten-nvim",
        dependencies = {
            "3rd/image.nvim",
            "GCBallesteros/jupytext.nvim",
        },
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 30
            vim.g.molten_auto_open_output = false
            vim.g.molten_virt_text_output = true
            -- vim.g.molten_output_win_cover_gutter = false
            -- vim.g.molten_output_win_style = "minimal"
            -- vim.g.molten_output_virt_lines = true
            vim.g.molten_virt_lines_off_by_1 = true
            -- vim.g.molten_use_border_highlights = true
            vim.g.molten_wrap_output = false
            -- vim.g.molten_output_show_more = true
        end,
        config = function()
            local wk = require("which-key")

            wk.register({
                ["<localleader>m"] = {
                    name = "+Molten",
                    i = { ":MoltenInit<CR>", "Molten Init" },
                    I = { ":MoltenInfo<CR>", "Molten Info" },
                    l = { ":MoltenEvaluateLine<CR>", "Molten Evaluate Line" },
                    r = { ":MoltenReevaluateCell<CR>", "Molten Reevaluate Cell" },
                    d = { ":MoltenDelete<CR>", "Molten Delete Cell" },
                    a = { "<esc>o```{python}<cr>```<esc>O", "Add Python Cell" },
                    h = { ":MoltenHideOutput<CR>", "Molten Hide Output" },
                    s = { ":MoltenShowOutput<CR>", "Molten Show Output" },
                    e = { ":MoltenEvaluateOperator<CR>", "Molten Evaluate Operator" },
                    b = { ":MoltenOpenInBrowser<CR>", "Molten Open In Browser" },
                    o = { ":MoltenShowOutput<CR>:noautocmd MoltenEnterOutput<CR>", "Molten Enter Output Window" },
                    E = { ":MoltenExportOutput<CR>", "Molten Export Output" },
                },
            })

            vim.keymap.set("v", "<localleader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, noremap = true, desc = "evaluate visual selection" })
        end,
    },
}
