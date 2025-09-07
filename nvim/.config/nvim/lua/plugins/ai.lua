return {
    -- {
    --     "zbirenbaum/copilot.lua",
    --     cond = not vim.g.vscode,
    --     cmd = "Copilot",
    --     build = ":Copilot auth",
    --     event = "InsertEnter",
    --     opts = {
    --         suggestion = {
    --             enabled = true,
    --             auto_trigger = true,
    --             keymap = {
    --                 accept = false, -- handled by nvim-cmp / blink.cmp
    --                 next = "<M-n>",
    --                 prev = "<M-p>",
    --                 accept_word = "<M-w>",
    --                 accept_line = "<M-l>",
    --                 dismiss = "<M-e>",
    --             },
    --         },
    --         panel = { enabled = false },
    --         filetypes = {
    --             markdown = true,
    --             help = true,
    --         },
    --     },
    -- },
    {
        "supermaven-inc/supermaven-nvim",
        cond = not vim.g.vscode,
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<M-l>",
                    clear_suggestion = "<M-e>",
                    accept_word = "<M-w>",
                },
            })
        end,
    },
}
