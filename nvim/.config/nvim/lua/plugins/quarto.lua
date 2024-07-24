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
                    languages = {
                        "r",
                        "python",
                        "julia",
                        "bash",
                        "lua",
                        "html",
                        "dot",
                        "javascript",
                        "typescript",
                        "ojs",
                    },
                },
                codeRunner = {
                    enabled = true,
                    default_method = "slime",
                },
            })

            local quarto = require("quarto")
            local runner = require("quarto.runner")

            nmap("<localleader>qa", ":QuartoActivate<CR>", "Activate")
            nmap("<localleader>qp", quarto.quartoPreview, "Preview")
            nmap("<localleader>qq", quarto.quartoClosePreview, "Close Preview")
            nmap("<localleader>qh", ":QuartoHelp ", "Help")
            nmap("<localleader>qe", ":lua require'otter'.export()<cr>", "Export")
            nmap("<localleader>qE", ":lua require'otter'.export(true)<cr>", "Export Overwrite")

            nmap("<localleader>qrr", runner.run_cell, "Run Cell")
            nmap("<localleader>qra", runner.run_above, "Run Cell and Above")
            nmap("<localleader>qrR", runner.run_all, "Run All Cells")
            nmap("<localleader>qrl", runner.run_line, "Run Line")
            nmap("<localleader>qrA", function()
                runner.run_all(true)
            end, "All Cells of All Languages")
            vmap("<localleader>qrr", runner.run_range, "Run Visual range")

            nmap("<leader>cr", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
            nmap("<leader>cp", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")

            imap("<M-r>", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
            imap("<M-e>", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")

            imap("<M-m>", function()
                runner.run_cell()
                vim.cmd("normal ]bzz")
            end, "Quarto Run Cell and move to next cell")

            require("which-key").add({
                { "<leader>c", group = "+Cell" },
                { "<localleader>q", group = "+Quarto" },
                { "<localleader>qr", group = "+Run" },
            })
        end,
    },

    {
        "HakonHarnes/img-clip.nvim",
        ft = { "markdown", "quarto" },
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
