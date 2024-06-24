return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            { "williamboman/mason.nvim", cmd = { "Mason" }, opts = {} },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },

            "p00f/clangd_extensions.nvim",
            { "microsoft/python-type-stubs", cond = false },
            { "barreiroleo/ltex-extra.nvim" },
            { "ray-x/lsp_signature.nvim" },
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
                    --  To jump back, press <C-t>.
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
                    map("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]earch Document [s]ymbols")

                    -- Fuzzy find all the symbols in your current workspace
                    --  Similar to document symbols, except searches over your whole project.
                    map("<leader>sS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]earch Workspace [S]ymbols")

                    -- Rename the variable under your cursor
                    --  Most Language Servers support renaming across files, etc.
                    map("gR", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map("ga", vim.lsp.buf.code_action, "[C]ode [A]ction")

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap
                    map("K", vim.lsp.buf.hover, "Hover Documentation")

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    map("gH", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                        vim.notify("Inlay hints " .. (vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) and "enabled" or "disabled"))
                    end, "Toggle Inlay [H]ints")

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

                    require("lsp_signature").on_attach({
                        doc_lines = 0,
                        toggle_key = "<C-k>",
                    }, bufnr)

                    vim.keymap.set({ "n" }, "<C-k>", function()
                        require("lsp_signature").toggle_float_win()
                    end, { silent = true, noremap = true, desc = "toggle signature" })
                end,
            })

            local utils = require("lspconfig").util
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local on_attach = function(client, buffer)
                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable()
                end
                if client.supports_method("textDocument/codeLens") then
                    vim.lsp.codelens.refresh()
                    --- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = buffer,
                        callback = vim.lsp.codelens.refresh,
                    })
                end
            end

            local servers = {
                basedpyright = {
                    settings = {
                        basedpyright = {
                            stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
                            typeCheckingMode = "standard",
                        },
                    },
                    on_attach = function(client, buffer)
                        on_attach(client, buffer)
                    end,
                    root_dir = utils.root_pattern({ ".git", ".venv" }),
                },
                clangd = {
                    -- capabilities = {
                    --     offsetEncoding = { 'utf-16' },
                    -- },
                    on_attach = function(client, buffer)
                        require("clangd_extensions.inlay_hints").setup_autocmd()
                        -- require("clangd_extensions.inlay_hints").set_inlay_hints()
                        on_attach(client, buffer)
                    end,
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            diagnostics = {
                                disable = { "missing-fields" },
                            },
                        },
                    },
                    on_attach = function(client, buffer)
                        on_attach(client, buffer)
                    end,
                },
                marksman = {
                    -- also needs:
                    -- $home/.config/marksman/config.toml :
                    -- [core]
                    -- markdown.file_extensions = ["md", "markdown", "qmd"]
                    filetypes = { "markdown", "quarto" },
                    root_dir = require("lspconfig.util").root_pattern(".git", ".marksman.toml", "_quarto.yml"),
                },
                r_language_server = {
                    on_attach = function(client, buffer)
                        on_attach(client, buffer)
                    end,
                },
                ruff = {
                    on_attach = function(client, _)
                        client.server_capabilities.hoverProvider = false
                    end,
                    root_dir = utils.root_pattern({ ".git", ".venv" }),
                },
                texlab = {
                    keys = {
                        { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
                    },
                    on_attach = function(client, buffer)
                        on_attach(client, buffer)
                    end,
                },
                taplo = {
                    keys = {
                        {
                            "K",
                            function()
                                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                                    require("crates").show_popup()
                                else
                                    vim.lsp.buf.hover()
                                end
                            end,
                            desc = "Show Crate Documentation",
                        },
                    },
                },
                ltex = {
                    settings = {
                        ltex = {
                            language = "en-US",
                            additionalRules = {
                                languageModel = "~/ngrams/",
                            },
                        },
                    },
                    on_attach = function(client, buffer)
                        require("ltex_extra").setup({})
                        on_attach(client, buffer)
                    end,
                },
            }

            require("mason").setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format lua code
                "bibtex-tidy",
                "clang-format",
                "shfmt",
                "latexindent",
                "codelldb",
                "debugpy",
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

            local icons = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " ",
            }
            local diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    -- prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                    prefix = function(diagnostic)
                        for d, icon in pairs(icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                return icon
                            end
                        end
                    end,
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

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })
        end,
    },
}
