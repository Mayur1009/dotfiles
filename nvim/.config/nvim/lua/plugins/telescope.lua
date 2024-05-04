return {
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for install instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "catgoose/telescope-helpgrep.nvim" },
            { "debugloop/telescope-undo.nvim" },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of help_tags options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`

            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")
            local all_toggle = false
            local recent_toggle = true

            require("telescope").setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                -- defaults = {
                --   mappings = {
                --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                --   },
                -- },
                -- pickers = {}
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
                defaults = {
                    mappings = {
                        i = {
                            ["<C-Down>"] = actions.cycle_history_next,
                            ["<C-Up>"] = actions.cycle_history_prev,
                            ["<a-r>"] = function()
                                recent_toggle = not recent_toggle
                                builtin.oldfiles({ only_cwd = recent_toggle })
                            end,
                            ["<a-a>"] = function()
                                all_toggle = not all_toggle
                                builtin.find_files({ no_ignore = all_toggle, no_ignore_parent = all_toggle })
                            end,
                            ["<a-e>"] = function()
                                builtin.find_files({ cwd = "$HOME/" })
                            end,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        follow = true,
                        hidden = true,
                    },
                    oldfiles = {
                        only_cwd = true,
                    },
                },
            })

            -- Enable telescope extensions, if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")
            pcall(require("telescope").load_extension, "helpgrep")
            pcall(require("telescope").load_extension, "undo")

            -- See `:help telescope.builtin`
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp_tags" })
            vim.keymap.set("n", "<leader>sH", "<cmd>Telescope helpgrep<cr>", { desc = "[S]earch [H]elpgrep" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sb", builtin.builtin, { desc = "[S]earch Telescope [B]uiltins" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Telescope [r]esume" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]iles live [G]rep" })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Search [R]ecent [F]iles" })
            vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>.", builtin.buffers, { desc = "Find existing buffers" })
            vim.keymap.set("n", "<leader>tu", "<cmd>Telescope undo<cr>", { desc = "[T]oggle [u]ndo tree" })

            -- Slightly advanced example of overriding default behavior and theme
            -- vim.keymap.set("n", "<leader>/", function()
            --     -- You can pass additional configuration to telescope to change theme, layout, etc.
            --     builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            --         winblend = 4,
            --         previewer = false,
            --     }))
            -- end, { desc = "[/] Fuzzily search in current buffer" })

            -- Also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            -- vim.keymap.set("n", "<leader>s/", function()
            --     builtin.live_grep({
            --         grep_open_files = true,
            --         prompt_title = "Live Grep in Open Files",
            --     })
            -- end, { desc = "[S]earch [/] in Open Files" })

            -- Shortcut for searching your neovim configuration files
            vim.keymap.set("n", "<leader>sc", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch Neovim [c]onfig files" })
        end,
        keys = {
            "<leader>sh",
            "<leader>sH",
            "<leader>sk",
            "<leader>sb",
            "<leader>sw",
            "<leader>sd",
            "<leader>sr",
            "<leader>fg",
            "<leader>fr",
            "<leader><leader>",
            "<leader>.",
            "<leader>sc",
        },
    },
}
