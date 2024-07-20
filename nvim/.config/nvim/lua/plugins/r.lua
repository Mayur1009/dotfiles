return {
    {
        "R-nvim/R.nvim",
        lazy = false,
        opts = {
            -- TODO: Configuration
            R_args = { "--quiet", "--no-save" },
            user_maps_only = true,
            Rout_more_colors = true,
            bracketed_paste = true,
            csv_app = "tmux neww vd",
            external_term = "tmux split-window -h -l 80",
            hook = {
                on_filetype = function()
                    -- TODO: define only important mappings https://github.com/R-nvim/R.nvim/blob/main/lua/r/maps.lua
                    local def_map = function(mode, map, cmd, desc)
                        vim.api.nvim_buf_set_keymap(0, mode, map, cmd, { desc = desc })
                    end

                    def_map('n', '<localleader>rf', "<Cmd>lua require('r.run').start_R('R')<cr>", "Start R")
                    def_map('n', '<localleader>rF', "<Cmd>lua require('r.run').start_R('custom')<cr>", "Start R with custom args")
                    def_map('n', '<localleader>rQ', "<Cmd>lua require('r.run').quit_R('nosave')<cr>", "Quit R nosave")
                    def_map('n', '<localleader>rq', "<Cmd>lua require('r.run').quit_R('save')<cr>", "Quit R with saving")

                    def_map('n', '<localleader>rh', "<Cmd>lua require('r.run').action('help')<cr>", "help")

                end,
            },
        },
        config = function(_, opts)
            vim.g.rout_follow_colorscheme = true
            require("r").setup(opts)
        end,
    },
}
