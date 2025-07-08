local get_cwd = function()
    local max_length = 30
    local home = vim.env.HOME
    local cwd = vim.fn.getcwd()
    cwd = "~" .. cwd:sub(#home + 1)
    if #cwd <= max_length then
        return cwd
    end

    -- Split path into components
    local parts = {}
    for part in string.gmatch(cwd, "[^/]+") do
        table.insert(parts, part)
    end

    local n = #parts
    local function join()
        return table.concat(parts, "/")
    end

    for i = 1, n - 1 do
        if #parts[i] > 1 then
            parts[i] = parts[i]:sub(1, 1)
        end
        if #join() <= max_length then
            return join()
        end
    end

    -- If still too long, clip the last part
    local last_part = parts[n]
    local cur_cwd = table.concat(parts, "/", 1, n - 1)
    local remaining = (max_length - #cur_cwd) <= 10 and 10 or (max_length - #cur_cwd)

    if #last_part > remaining then
        cur_cwd = cur_cwd .. "/" .. last_part:sub(1, remaining - 4) .. "..."
    else
        cur_cwd = cur_cwd .. "/" .. last_part
    end

    return cur_cwd
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
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return str:sub(1, 4)
                            end,
                        },
                    },
                    lualine_b = { "branch", get_cwd },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = {
                                modified = "[+]",
                                readonly = "",
                                unnamed = "[No Name]",
                            },
                        },
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
                    },
                    lualine_y = { "lsp_status", "diagnostics", "diff", "filetype" },
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
