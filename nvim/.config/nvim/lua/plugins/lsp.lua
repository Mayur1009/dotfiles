return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        dependencies = {
            { "williamboman/mason.nvim", cmd = { "Mason" }, opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            { "saghen/blink.cmp" },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself
                    -- many times.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local bufnr = event.buf
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press<C-t>.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- Find references for the word under your cursor.
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map("gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("gy", require("telescope.builtin").lsp_document_symbols, "[S]earch Document [s]ymbols")

                    -- Fuzzy find all the symbols in your current workspace
                    --  Similar to document symbols, except searches over your whole project.
                    map(
                        "gY",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[S]earch Workspace [S]ymbols"
                    )

                    -- Rename the variable under your cursor
                    --  Most Language Servers support renaming across files, etc.
                    map("gR", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("ga", vim.lsp.buf.code_action, "[C]ode [A]ction")

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    map("gH", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                            { bufnr = bufnr }
                        )
                        vim.notify(
                            "Inlay hints "
                                .. (vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) and "enabled" or "disabled")
                        )
                    end, "Toggle Inlay [H]ints")

                    map("gF", vim.lsp.buf.format, "[F]ormat")
                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.server_capabilities.documentHighlightProvider then
                    --     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --
                    --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    --         buffer = event.buf,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    -- end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

            local lsputil = require("lspconfig.util")
            local servers = {
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
                -- harper_ls = {
                --     settings = {
                --         ["harper-ls"] = {
                --             diagnosticSeverity = "information",
                --             userDictPath = vim.fn.stdpath("config") .. "/harper-dict.txt",
                --         },
                --     },
                -- },
                lua_ls = {
                    settings = {
                        Lua = {
                            hint = {
                                enabled = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                            diagnostics = {
                                globals = {
                                    "awesome",
                                    "awful",
                                    "client",
                                    "screen",
                                    "tag",
                                    "root",
                                },
                            },
                            runtime = { version = "LuaJIT" },
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- You can toggle below to ignore lua_ls's noisy `missing-fields` warnings
                            -- diagnostics = {
                            --     disable = { "missing-fields" },
                            -- },
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
                neocmake = {},
                r_language_server = {
                    root_dir = function(fname)
                        return lsputil.root_pattern("DESCRIPTION", "NAMESPACE", ".Rbuildignore")(fname)
                            or lsputil.find_git_ancestor(fname)
                            or vim.fn.expand("$HOME")
                    end,
                },
                ruff = {
                    root_dir = lsputil.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml")
                        or lsputil.find_git_ancestor()
                        or vim.fn.expand("$HOME"),
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
                -- ltex = {
                --     settings = {
                --         ltex = {
                --             language = "en-US",
                --             additionalRules = {
                --                 languageModel = "~/ngrams/",
                --             },
                --         },
                --     },
                --     on_attach = function(_, _)
                --         require("ltex_extra").setup({})
                --     end,
                -- },
            }

            require("mason").setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "bibtex-tidy",
                "clang-format",
                "shfmt",
                "latexindent",
                "codelldb",
                "debugpy",
                "hyprls",
                "cmakelang",
                "shellcheck",
                "ruff",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers or {}),
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
            require("lspconfig").hyprls.setup({})

            local icons = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " ",
            }
            local function prefix(diagnostic)
                for d, icon in pairs(icons) do
                    if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                        return icon
                    end
                end
            end
            local diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = prefix,
                },
                float = {
                    border = "rounded",
                    prefix = prefix,
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = icons.Error,
                        [vim.diagnostic.severity.WARN] = icons.Warn,
                        [vim.diagnostic.severity.HINT] = icons.Hint,
                        [vim.diagnostic.severity.INFO] = icons.Info,
                    },
                },
            }
            for severity, icon in pairs(diagnostics.signs.text) do
                local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end
            vim.diagnostic.config(vim.deepcopy(diagnostics))

            vim.keymap.set("n", "<leader>tD", function()
                local vt = vim.diagnostic.config().virtual_text
                if vt == false then
                    vim.diagnostic.config({
                        virtual_text = {
                            spacing = 4,
                            source = "if_many",
                            prefix = prefix,
                        },
                    })
                else
                    vim.diagnostic.config({ virtual_text = false })
                end
                vim.print(vim.diagnostic.config())
            end, { desc = "Toggle diagnostic virtual text" })

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4", -- Recommended
        ft = { "rust" },
    },
}
