local function augroup(name)
    return vim.api.nvim_create_augroup("kickstart_" .. name, { clear = true })
end
return {
    {
        "ThePrimeagen/refactoring.nvim",
        event = { "BufReadPost" },
        cmd = { "Refactor" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local refactoring = require("refactoring")
            refactoring.setup({})
            vim.keymap.set({ "n", "x" }, "<leader>rm", function()
                refactoring.select_refactor({})
            end, { desc = "Refactoring Menu" })
            vim.keymap.set("n", "<leader>rd", function()
                require("refactoring").debug.printf({ below = false })
            end, { desc = "Refactoring debug print statement" })
            vim.keymap.set("n", "<leader>rv", function()
                require("refactoring").debug.print_var({})
            end, { desc = "Refactoring print var" })
            vim.keymap.set("n", "<leader>rc", function()
                require("refactoring").debug.cleanup({})
            end, { desc = "Refactoring print cleanup" })
            require("which-key").add({
                "<leader>r",
                group = "+[r]efactoring",
            })
        end,
        keys = {},
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python", --optional
            "nvim-telescope/telescope.nvim",
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            local function shorter_name(filename)
                return filename:gsub(os.getenv("HOME"), "~"):gsub("/bin/python", "")
            end
            local vs = require("venv-selector")
            vs.setup({
                settings = {
                    search = {
                        miniforge3_base = {
                            command = "fd /python$ ~/miniforge3/bin --full-path --color never -E /proc",
                            type = "anaconda",
                            on_telescope_result_callback = shorter_name,
                        },
                        miniforge3_envs = {
                            command = "fd bin/python$ ~/miniforge3/envs --full-path --color never -E /proc",
                            type = "anaconda",
                            on_telescope_result_callback = shorter_name,
                        },
                    },
                },
            })
            vim.keymap.set("n", "<localleader>va", "<cmd>VenvSelect<cr>", { desc = "Activate Venv" })
            vim.keymap.set("n", "<localleader>vd", vs.deactivate, { desc = "Deactivate Venv" })
            require("which-key").add({
                "<localleader>v",
                group = "+Venv",
            })
        end,
    },
    {
        "jpalardy/vim-slime",
        event = "VeryLazy",
        init = function()
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_target = vim.g.code_target
            vim.g.slime_default_config = {
                socket_name = "default",
                target_pane = "2",
            }
            vim.keymap.set("v", "<M-s>", "<Plug>SlimeRegionSend", { desc = "Slime Region Send" })
            vim.keymap.set({ "n", "i" }, "<M-s><M-s>", "<Plug>SlimeLineSend", { desc = "Slime Line Send" })
            vim.keymap.set("n", "<M-s>", "<Plug>SlimeMotionSend", { desc = "Slime Motion Send" })
            vim.keymap.set("n", "<M-s><CR>", "<Plug>SlimeSendCell", { desc = "Slime Motion Send" })

            vim.fn.sign_define("SlimeCellTop", { linehl = "SlimeCellBoundaryTop" })
            vim.api.nvim_set_hl(0, "SlimeCellBoundaryTop", { underline = true, fg = "#6183bb" })

            vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP", "BufEnter" }, {
                group = augroup("slime_cell_py"),
                pattern = {
                    "*.py",
                },
                callback = function(event)
                    -- Taken from https://github.com/Klafyvel/vim-slime-cells
                    local buf = event.buf
                    local cell_delimiter
                    if vim.b.slime_cell_delimiter then
                        cell_delimiter = vim.b.slime_cell_delimiter
                    elseif vim.g.slime_cell_delimiter then
                        cell_delimiter = vim.g.slime_cell_delimiter
                    else
                        return
                    end
                    vim.fn.sign_unplace("slime_cells_top")
                    local l = vim.fn.getline(1, "$")
                    vim.fn.map(l, function(key, value)
                        if vim.fn.match(value, cell_delimiter) >= 0 then
                            vim.fn.sign_place(0, "slime_cells_top", "SlimeCellTop", buf, { lnum = key + 1 })
                        end
                    end)
                end,
            })
        end,
    },
    {
        "folke/trouble.nvim",
        event = { "BufReadPost", "LspAttach" },
        config = function()
            require("trouble").setup({
                focus = true,
            })
            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Diagnostics" })
            vim.keymap.set(
                "n",
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                { desc = "Toggle Diagnostics cur buf" }
            )
            vim.keymap.set(
                "n",
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                { desc = "Toggle Symbols" }
            )
            vim.keymap.set(
                "n",
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false<cr>",
                { desc = "Toggle LSP Def/Ref..." }
            )
            vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Toggle Loc List" })
            vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Toggle Quickfix List" })
            vim.keymap.set("n", "<leader>xf", require("trouble").focus, { desc = "Focus Trouble" })
            require("which-key").add({
                "<leader>x",
                group = "+Trouble",
            })
        end,

        keys = {
            "<leader>xx",
            "<leader>xX",
            "<leader>xs",
            "<leader>xl",
            "<leader>xL",
            "<leader>xQ",
            "<leader>xf",
        },
    },
    {
        "benlubas/molten-nvim",
        dependencies = {
            "3rd/image.nvim",
        },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_auto_image_popup = true
            vim.g.molten_auto_open_output = true
            vim.g.molten_image_provider = "none"
            vim.g.molten_output_show_more = true
            vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            vim.g.molten_output_win_max_height = 15
            vim.g.molten_output_win_cover_gutter = false
            vim.g.molten_use_border_highlights = true
            vim.g.molten_wrap_output = true
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_max_lines = 15
        end,
        config = function()
            vim.keymap.set({ "n", "i" }, "<M-m>", ":MoltenEvaluateOperator<CR>", { desc = "Molten evaluate operator" })
            vim.keymap.set({ "v" }, "<M-m>", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten evaluate Visual" })
            vim.keymap.set("n", "<localleader>mr", ":MoltenReevaluateCell<CR>", { desc = "re-evaluate cell" })
            vim.keymap.set("n", "<localleader>mo", ":noautocmd MoltenEnterOutput<CR>", { desc = "open output window" })
            vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { desc = "hide output" })
            vim.keymap.set("n", "<localleader>ms", ":MoltenShowOutput<CR>", { desc = "show output" })
            vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { desc = "Image popup" })
            vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>", { desc = "open output in browser" })
            vim.keymap.set("n", "<localleader>me", ":MoltenExportOutput!<CR>", { desc = "Export output" })
            vim.keymap.set("n", "<localleader>mE", ":MoltenImportOutput<CR>", { desc = "Import Output" })
            vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize the plugin" })
            vim.keymap.set("n", "<localleader>mI", ":MoltenInfo<CR>", { desc = "Molten Info" })

            require("which-key").add({
                { "<localleader>m", group = "+Molten" },
            })

            vim.api.nvim_set_hl(0, "MoltenCell", {})
            vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { link = "DiagnosticOk" })
            vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { link = "DiagnosticError" })

            -- automatically import output chunks from a jupyter notebook
            -- tries to find a kernel that matches the kernel in the jupyter notebook
            -- falls back to a kernel that matches the name of the active venv (if any)
            local imb = function(e) -- init molten buffer
                vim.schedule(function()
                    local kernels = vim.fn.MoltenAvailableKernels()
                    local try_kernel_name = function()
                        local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
                        return metadata.kernelspec.name
                    end
                    local ok, kernel_name = pcall(try_kernel_name)
                    if not ok or not vim.tbl_contains(kernels, kernel_name) then
                        kernel_name = nil
                        local venv = os.getenv("VIRTUAL_ENV")
                        if venv ~= nil then
                            kernel_name = string.match(venv, "/.+/(.+)")
                        end
                    end
                    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                        vim.cmd(("MoltenInit %s"):format(kernel_name))
                    end
                    vim.cmd("MoltenImportOutput")
                end)
            end

            -- automatically import output chunks from a jupyter notebook
            vim.api.nvim_create_autocmd("BufAdd", {
                group = augroup("molten_import_output"),
                pattern = { "*.ipynb" },
                callback = imb,
            })

            -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
            vim.api.nvim_create_autocmd("BufEnter", {
                group = augroup("molten_import_output2"),
                pattern = { "*.ipynb" },
                callback = function(e)
                    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
                        imb(e)
                    end
                end,
            })

            -- automatically export output chunks to a jupyter notebook on write
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = augroup("molten_export_output"),
                pattern = { "*.ipynb" },
                callback = function()
                    if require("molten.status").initialized() == "Molten" then
                        vim.cmd("MoltenExportOutput!")
                    end
                end,
            })

            -- change the configuration when editing a python file
            vim.api.nvim_create_autocmd("BufEnter", {
                group = augroup("molten_py_config"),
                pattern = "*.py",
                callback = function(e)
                    if string.match(e.file, ".otter.") then
                        return
                    end
                    if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
                        vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
                        vim.fn.MoltenUpdateOption("virt_text_output", false)
                    else
                        vim.g.molten_virt_lines_off_by_1 = false
                        vim.g.molten_virt_text_output = false
                    end
                end,
            })

            -- Undo those config changes when we go back to a markdown or quarto file
            vim.api.nvim_create_autocmd("BufEnter", {
                group = augroup("molten_nb_config"),
                pattern = { "*.qmd", "*.md", "*.ipynb" },
                callback = function(e)
                    if string.match(e.file, ".otter.") then
                        return
                    end
                    if require("molten.status").initialized() == "Molten" then
                        vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
                        vim.fn.MoltenUpdateOption("virt_text_output", true)
                    else
                        vim.g.molten_virt_lines_off_by_1 = true
                        vim.g.molten_virt_text_output = true
                    end
                end,
            })

            -- Provide a command to create a blank new Python notebook
            -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
            -- if you use another language than Python, you should change it in the template.
            local default_notebook = [[
             {
                "cells": [
                {
                "cell_type": "markdown",
                "metadata": {},
                "source": [
                    ""
                ]
                }
                ],
                "metadata": {
                "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3"
                },
                "language_info": {
                "codemirror_mode": {
                    "name": "ipython"
                },
                "file_extension": ".py",
                "mimetype": "text/x-python",
                "name": "python",
                "nbconvert_exporter": "python",
                "pygments_lexer": "ipython3"
                }
                },
                "nbformat": 4,
                "nbformat_minor": 5
            }
           ]]

            local function new_notebook(filename)
                local path = filename .. ".ipynb"
                local file = io.open(path, "w")
                if file then
                    file:write(default_notebook)
                    file:close()
                    vim.cmd("edit " .. path)
                else
                    print("Error: Could not open new notebook file for writing.")
                end
            end

            vim.api.nvim_create_user_command("Nb", function(opts)
                new_notebook(opts.args)
            end, {
                nargs = 1,
                complete = "file",
            })
        end,
    },
}
