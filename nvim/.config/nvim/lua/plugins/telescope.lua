return {
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        -- branch = "0.1.x",
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

            -- Useful for getting pretty icons, but requires a Nerd Font.
            -- { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
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

            -- See `:help telescope.builtin`
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp_tags" })
            vim.keymap.set("n", "<leader>sH", "<cmd>Telescope helpgrep<cr>", { desc = "[S]earch [H]elpgrep" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sb", builtin.builtin, { desc = "[S]earch Telescope [B]uiltins" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Telescope [R]esume" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch live [G]rep" })
            vim.keymap.set("n", "<leader>sr", builtin.oldfiles, { desc = "Search [R]ecent [F]iles" })
            vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Search files" })
            vim.keymap.set("n", "<leader><tab>", builtin.buffers, { desc = "List existing buffers" })
            vim.keymap.set("n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 5,
                    previewer = false,
                })
                )
            end, { desc = "[/] Fuzzily search in current buffer" })

            vim.keymap.set("n", "<leader>sc", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[S]earch Neovim [c]onfig files" })

            require("which-key").add({
                "<leader>s", group = "+[s]earch",
            })
        end,
        keys = {
            "<leader>sh",
            "<leader>sH",
            "<leader>sk",
            "<leader>sb",
            "<leader>sd",
            "<leader>sr",
            "<leader>sg",
            "<leader>sR",
            "<leader><leader>",
            "<leader><tab>",
            "<leader>/",
            "<leader>sc",
        },
    },
}
