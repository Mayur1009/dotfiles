return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-y>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-n>",
                        prev = "<M-p>",
                        dismiss = "<M-d>",
                    },
                },
                panel = {
                    layout = {
                        position = "right",
                        ratio = 0.4,
                    },
                },
            })

            -- local cmp = require(cmp)
            -- cmp.event:on("menu_opened", function()
            --     vim.b.copilot_suggestion_hidden = true
            -- end)
            -- cmp.event:on("menu_closed", function()
            --     vim.b.copilot_suggestion_hidden = false
            -- end)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        optional = true,
        event = "VeryLazy",
        opts = function(_, opts)
            local Util = require("lazyvim.util").ui
            local colors = {
                [""] = Util.fg("Special"),
                ["Normal"] = Util.fg("Special"),
                ["Warning"] = Util.fg("DiagnosticError"),
                ["InProgress"] = Util.fg("DiagnosticWarn"),
            }
            table.insert(opts.sections.lualine_x, 2, {
                function()
                    local icon = require("lazyvim.config").icons.kinds.Copilot
                    local status = require("copilot.api").status.data
                    return icon .. (status.message or "")
                end,
                cond = function()
                    if not package.loaded["copilot"] then
                        return
                    end
                    local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
                    if not ok then
                        return false
                    end
                    return ok and #clients > 0
                end,
                color = function()
                    if not package.loaded["copilot"] then
                        return
                    end
                    local status = require("copilot.api").status.data
                    return colors[status.status] or colors[""]
                end,
            })
        end,
    },
}
