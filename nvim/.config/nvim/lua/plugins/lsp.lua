return {
    {
        -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },

            -- Allows extra capabilities provided by blink.cmp
            "saghen/blink.cmp",
        },
        config = function()
            local lsputil = require("lspconfig.util")
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("grn", vim.lsp.buf.rename, "Lsp Rename")
                    map("gra", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
                    map("gF", vim.lsp.buf.format, "Lsp Format")

                end,
            })

            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                } or {},
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            -- LSP Server Settings
            local servers = {
                clangd = {
                    settings = {
                        clangd = {
                            InlayHints = {
                                Designators = true,
                                Enabled = true,
                                ParameterNames = true,
                                DeducedTypes = true,
                            },
                            fallbackFlags = { "-std=c++20" },
                        },
                    },
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            codeLens = {
                                enable = true,
                            },
                            doc = {
                                privateName = { "^_" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },

                marksman = {
                    -- also needs:
                    -- $home/.config/marksman/config.toml :
                    -- [core]
                    -- markdown.file_extensions = ["md", "markdown", "qmd"]
                    filetypes = { "markdown", "quarto" },
                    root_dir = lsputil.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
                },

                basedpyright = {
                    settings = {
                        basedpyright = {
                            disableOrganizeImports = true,
                            -- analysis = {
                            --     diagnosticsMode = "workspace",
                            -- },
                        },
                    },
                },
                bashls = {},

                ruff = {
                    on_attach = function(client, _)
                        client.server_capabilities.hoverProvider = false
                    end,
                },
                texlab = {
                    keys = {
                        { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
                    },
                },
                yamlls = {
                    settings = {
                        yaml = {
                            schemaStore = {
                                enable = true,
                                url = "",
                            },
                        },
                    },
                },
                zls = {},
                neocmake = {},
                taplo = {},
                dockerls = {},
                docker_compose_language_service = {},
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format Lua code
                "markdownlint-cli2",
                "markdown-toc",
                "bibtex-tidy",
                "latexindent",
                "shfmt",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
                { path = "wezterm-types", mods = { "wezterm" } },
                "/usr/share/awesome/lib",
                "/usr/share/lua",
            },
        },
    },
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
    },

    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {},
    },
}
