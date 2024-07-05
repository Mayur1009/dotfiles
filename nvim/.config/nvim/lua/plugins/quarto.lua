local nmap = function(key, effect, desc)
    vim.keymap.set("n", key, effect, { desc = desc, silent = true, noremap = true })
end

local vmap = function(key, effect, desc)
    vim.keymap.set("v", key, effect, { desc = desc, silent = true, noremap = true })
end

local imap = function(key, effect, desc)
    vim.keymap.set("i", key, effect, { desc = desc, silent = true, noremap = true })
end

return {
    {
        "quarto-dev/quarto-nvim",
        dev = false,
        ft = { "quarto", "markdown" },
        dependencies = {
            "jpalardy/vim-slime",
            {
                "jmbuhr/otter.nvim",
                dependencies = {
                    "nvim-treesitter/nvim-treesitter",
                },
                opts = {
                    lsp = {
                        diagnostic_update_events = { "BufWritePost", "CompleteDone", "TextChangedI" },
                    },
                    buffers = {
                        set_filetype = true,
                        write_to_disk = true,
                    },
                    handle_leading_whitespace = true,
                },
            },
        },
        config = function()
            require("quarto").setup({
                lspFeatures = {
                    languages = { "r", "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
                },
                codeRunner = {
                    enabled = true,
                    default_method = "slime",
                },
            })

            local quarto = require("quarto")
            local runner = require("quarto.runner")

            nmap("<leader>qa", ":QuartoActivate<CR>", "Activate")
            nmap("<leader>qp", quarto.quartoPreview, "Preview")
            nmap("<leader>qq", quarto.quartoClosePreview, "Close Preview")
            nmap("<leader>qh", ":QuartoHelp ", "Help")
            nmap("<leader>qe", ":lua require'otter'.export()<cr>", "Export")
            nmap("<leader>qE", ":lua require'otter'.export(true)<cr>", "Export Overwrite")

            nmap("<leader>rr", runner.run_cell, "Run Cell")
            nmap("<leader>ra", runner.run_above, "Run Cell and Above")
            nmap("<leader>rR", runner.run_all, "Run All Cells")
            nmap("<leader>rl", runner.run_line, "Run Line")
            nmap("<leader>rA", function()
                runner.run_all(true)
            end, "All Cells of All Languages")
            vmap("<leader>rr", runner.run_range, "Run Visual range")

            nmap("<leader>cr", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
            nmap("<leader>cp", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")

            imap("<M-r>", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
            imap("<M-e>", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")

            imap("<M-m>", function()
                runner.run_cell()
                vim.cmd("normal ]bzz")
            end, "Quarto Run Cell and move to next cell")

            require("which-key").register({
                ["<leader>q"] = { name = "+Quarto", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "+Run", _ = "which_key_ignore" },
                ["<leader>c"] = { name = "+Code/Cell", _ = "which_key_ignore" },
            })
        end,
    },

    {
        "HakonHarnes/img-clip.nvim",
        event = "BufEnter",
        opts = {
            filetypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
                quarto = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
            },
        },
    },
}
