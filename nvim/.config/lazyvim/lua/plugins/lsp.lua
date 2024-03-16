local util = require("lspconfig.util")

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "microsoft/python-type-stubs",
                cond = false,
            },
        },
        opts = {
            -- inlay_hints = {
            --     enabled = true,
            -- },
            setup = {
                clangd = function(_, opts)
                    opts.capabilities.offsetEncoding = { "utf-16" }
                end,
            },
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = {
                                checkThirdParty = false,
                                -- Tells lua_ls where to find all the Lua files that you have loaded
                                -- for your neovim configuration.
                                library = {
                                    "${3rd}/luv/library",
                                    unpack(vim.api.nvim_get_runtime_file("", true)),
                                },
                                -- If lua_ls is really slow on your computer, you can try this instead:
                                -- library = { vim.env.VIMRUNTIME },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                            analysis = {
                                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                            },
                        },
                    },
                },
                r_language_server = {
                    settings = {
                        r = {
                            lsp = {
                                rich_documentation = false,
                            },
                        },
                    },
                },
                marksman = {
                    -- also needs:
                    -- $home/.config/marksman/config.toml :
                    -- [core]
                    -- markdown.file_extensions = ["md", "markdown", "qmd"]
                    filetypes = { "markdown", "quarto" },
                    root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
                },
            },
        },
    },
}
