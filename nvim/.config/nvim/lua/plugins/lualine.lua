local cwd = function()
    local dir = vim.fn.getcwd()
    return dir
end
return {
    {
        "nvim-lualine/lualine.nvim",
        event = { "VeryLazy" },
        config = function()
            local lualine = require("lualine")
            lualine.setup({
                options = {
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                    always_divide_middle = false,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { {
                        "mode",
                        fmt = function(str)
                            return str:sub(1, 4)
                        end,
                    } },
                    lualine_b = { "branch", cwd },
                    -- lualine_c = {},
                    lualine_c = {
                        {
                            "filename",
                            path=1,
                            symbols = {
                                modified = "[+]",
                                readonly = "",
                                unnamed = "[No Name]",
                            },
                        }
                        -- {
                        --     "buffers",
                        --     show_filename_only = false,
                        --     use_mode_colors = true,
                        -- },
                    },
                    lualine_x = {
                        {
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"] and require("dap").status() ~= ""
                            end,
                            color = function()
                                return { fg = Snacks.util.color("Debug") }
                            end,
                        },
                        "lsp_status",
                    },
                    lualine_y = { "diagnostics", "diff", "filetype" },
                    lualine_z = {
                        "encoding",
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                extensions = { "lazy" },
            })
        end,
    },
}
