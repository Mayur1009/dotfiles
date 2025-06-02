local M = {}

---@type table<string, vim.lsp.Config>
M.lsp_config = {
    lua_ls = {
        settings = {
            version = "LuaJIT",
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
            },
        },
    },
    texlab = {
        settings = {
            texlab = {
                inlayHints = {
                    maxLength = 12,
                },
                latexindent = {
                    ["local"] = "localSettings.yaml",
                    modifyLineBreaks = true,
                },
            },
        },
    },
    harper_ls = {
        settings = {
            ["harper-ls"] = {
                userDictPath = vim.fn.stdpath("config") .. "/.harper_dict.txt",
            },
        },
    },
    basedpyright = {},
    ruff = {},
    clangd = {},
    neocmake = {},
    dockerls = {},
    docker_compose_language_service = {},
    marksman = {},
    taplo = {},
    zls = {},
}

local diagnostic_icons = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}

M.setup = function()
    -- Diagnostic signs and icons
    vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
        },
        float = {
            border = "rounded",
            prefix = "●",
        },
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
                [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
                [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
                [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
            },
        },
    })

    -- Enable LSP servers
    for name, config in pairs(M.lsp_config) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
    end

    -- Setup lsp keybinds, inlay hints, etc. with autocommands
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my_nvim_lsp_attach", { clear = true }),
        callback = function(event)
            local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
            local bufnr = event.buf
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end
            map("gd", Snacks.picker.lsp_definitions, "[G]oto [D]efinition")
            map("gD", Snacks.picker.lsp_declarations, "[G]oto [D]eclaration")
            map("gr", Snacks.picker.lsp_references, "[G]oto [R]eferences")
            map("gI", Snacks.picker.lsp_implementations, "[G]oto [I]mplementation")
            map("gy", Snacks.picker.lsp_type_definitions, "Type [D]efinition")
            map("<leader>ss", Snacks.picker.lsp_symbols, "Document [s]ymbols")
            map("<leader>sS", Snacks.picker.lsp_workspace_symbols, "Workspace [S]ymbols")
            map("gR", vim.lsp.buf.rename, "[R]e[n]ame")
            map("gA", vim.lsp.buf.code_action, "[C]ode [A]ction")
            map("gF", vim.lsp.buf.format, "[F]ormat")
            map("K", function()
                vim.lsp.buf.hover({
                    border = "rounded",
                })
            end, "Hover Documentation")

            if client:supports_method("textDocument/inlayHints") then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
        end,
    })
end

return M
