return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "letieu/harpoon-lualine",
        },
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {

                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "┃", right = "┃" },
                    section_separators = { left = "", right = "" },
                    always_divide_middle = false,
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                local cur_width = vim.o.laststatus == 3 and vim.o.columns
                                    or vim.api.nvim_win_get_width(0)
                                return cur_width < 100 and str:sub(1, 1) or str
                            end,
                        },
                    },
                    -- lualine_b = {},
                    lualine_c = {
                        { "filename", path = 1, shorting_target = 100 },
                        -- {
                        --     "buffers",
                        --     symbols = {
                        --         alternate_file = "# ",
                        --     },
                        -- },
                    },
                    lualine_x = {
                        {
                            "harpoon2",
                            _separator = "",
                            no_harpoon = "",
                        },
                        function()
                            if require("molten.status").kernels():len() > 0 then
                                return "󰰇 " .. require("molten.status").kernels()
                            else
                                return ""
                            end
                        end,
                    },
                    lualine_y = {
                        "filetype",

                    },
                    lualine_z = {
                        "%2l:%-2v",
                    },
                },
                extensions = { "lazy", "man", "mason", "oil", "quickfix", "trouble" },
            })
        end,
    },
}
