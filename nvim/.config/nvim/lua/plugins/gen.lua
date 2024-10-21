return {
    {
        "David-Kunz/gen.nvim",
        opts = {
            model = "codegemma",
            display_mode = "split",
            show_prompt = true,
            show_model = true,
            no_auto_close = false,
            file = false,
            hidden = false,
        },
        config = function(_, opts)
            require("gen").prompts["Elaborate_Text"] = {
                prompt = "Elaborate the following text:\n$text",
            }
            require("gen").prompts["Comment"] = {
                prompt = "Write comments for the following code:\n```$filetype\n$text\n```",
                extract = "```$filetype\n(.-)```",
            }
            require("gen").setup(opts)
            vim.keymap.set({ "n", "v" }, "<localleader>g", ":Gen<CR>", { desc = "Gen.nvim Prompt" })
        end,
    },
}
