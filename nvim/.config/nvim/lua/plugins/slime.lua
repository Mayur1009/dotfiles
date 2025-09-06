return {
    {
        "jpalardy/vim-slime",
        cond = not vim.g.vscode,
        ft = { "python", "quarto", "markdown" },
        init = function()
            if vim.env.TMUX == nil then
                vim.g.slime_target = "neovim"
            else
                vim.g.slime_target = "tmux"
                vim.g.slime_default_config = {
                    socket_name = "default",
                    target_pane = 2,
                }
            end
            vim.g.slime_no_mappings = 1
            vim.g.slime_bracketed_paste = 1
        end,
        keys = {
            { "<M-e>", "<Plug>SlimeMotionSend", desc = "Slime motion", mode = { "n" } },
            { "<M-e>", "<Plug>SlimeRegionSend<cr>", desc = "Slime region send", mode = "v" },
            { "<M-e>l", "<Plug>SlimeLineSend<cr>", desc = "Slime line send" },
            {
                "<M-e><M-e>",
                function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<M-e>ij", true, false, true), "o", false)
                end,
                desc = "Slime send Code block",
            },
        },
    },
}
