return {
    {
        "dustinblackman/oatmeal.nvim",
        cmd = { "Oatmeal" },
        opts = {
            backend = "ollama",
            model = "codegemma:latest",
        },
        keys = {
            { "<leader>om", mode = "n", desc = "Start Oatmeal session" },
        },
    },
}
