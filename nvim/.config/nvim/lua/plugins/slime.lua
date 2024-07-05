return {
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_target = "tmux"
            vim.g.slime_default_config = {
                socket_name = "default",
                target_pane = "2"
            }
            vim.keymap.set("v", "<M-s>", "<Plug>SlimeRegionSend", { desc = "Slime Region Send" })
            vim.keymap.set({ "n", "i" }, "<M-s><M-s>", "<Plug>SlimeLineSend", { desc = "Slime Line Send" })
            vim.keymap.set("n", "<M-s>", "<Plug>SlimeMotionSend", { desc = "Slime Motion Send" })
            vim.keymap.set("n", "<M-s><CR>", "<Plug>SlimeSendCell", { desc = "Slime Motion Send" })
        end,
    },
    {
        "klafyvel/vim-slime-cells",
        ft = { "python" },
        dependencies = { "jpalardy/vim-slime" },
        config = function()
            vim.g.slime_cell_delimiter = "#%%"
        end
    }
}
