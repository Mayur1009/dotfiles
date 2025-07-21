local function augroup(name)
    return vim.api.nvim_create_augroup("kickstart_" .. name, { clear = true })
end

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

return {
    {
        "benlubas/molten-nvim",
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

            -- -- automatically import output chunks from a jupyter notebook
            -- -- tries to find a kernel that matches the kernel in the jupyter notebook
            -- -- falls back to a kernel that matches the name of the active venv (if any)
            -- local imb = function(e) -- init molten buffer
            --     vim.schedule(function()
            --         local kernels = vim.fn.MoltenAvailableKernels()
            --         local try_kernel_name = function()
            --             local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
            --             return metadata.kernelspec.name
            --         end
            --         local ok, kernel_name = pcall(try_kernel_name)
            --         if not ok or not vim.tbl_contains(kernels, kernel_name) then
            --             kernel_name = nil
            --             local venv = os.getenv("VIRTUAL_ENV")
            --             if venv ~= nil then
            --                 kernel_name = string.match(venv, "/.+/(.+)")
            --             end
            --         end
            --         if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            --             vim.cmd(("MoltenInit %s"):format(kernel_name))
            --         end
            --         vim.cmd("MoltenImportOutput")
            --     end)
            -- end
            --
            -- -- automatically import output chunks from a jupyter notebook
            -- vim.api.nvim_create_autocmd("BufAdd", {
            --     group = augroup("molten_import_output"),
            --     pattern = { "*.ipynb" },
            --     callback = imb,
            -- })
            --
            -- -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
            -- vim.api.nvim_create_autocmd("BufEnter", {
            --     group = augroup("molten_import_output2"),
            --     pattern = { "*.ipynb" },
            --     callback = function(e)
            --         if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            --             imb(e)
            --         end
            --     end,
            -- })
            --
            -- -- automatically export output chunks to a jupyter notebook on write
            -- vim.api.nvim_create_autocmd("BufWritePost", {
            --     group = augroup("molten_export_output"),
            --     pattern = { "*.ipynb" },
            --     callback = function()
            --         if require("molten.status").initialized() == "Molten" then
            --             vim.cmd("MoltenExportOutput!")
            --         end
            --     end,
            -- })
            --
            -- -- change the configuration when editing a python file
            -- vim.api.nvim_create_autocmd("BufEnter", {
            --     group = augroup("molten_py_config"),
            --     pattern = "*.py",
            --     callback = function(e)
            --         if string.match(e.file, ".otter.") then
            --             return
            --         end
            --         if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
            --             vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
            --             vim.fn.MoltenUpdateOption("virt_text_output", false)
            --         else
            --             vim.g.molten_virt_lines_off_by_1 = false
            --             vim.g.molten_virt_text_output = false
            --         end
            --     end,
            -- })
            --
            -- -- Undo those config changes when we go back to a markdown or quarto file
            -- vim.api.nvim_create_autocmd("BufEnter", {
            --     group = augroup("molten_nb_config"),
            --     pattern = { "*.qmd", "*.md", "*.ipynb" },
            --     callback = function(e)
            --         if string.match(e.file, ".otter.") then
            --             return
            --         end
            --         if require("molten.status").initialized() == "Molten" then
            --             vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
            --             vim.fn.MoltenUpdateOption("virt_text_output", true)
            --         else
            --             vim.g.molten_virt_lines_off_by_1 = true
            --             vim.g.molten_virt_text_output = true
            --         end
            --     end,
            -- })

            -- Provide a command to create a blank new Python notebook
            -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
            -- if you use another language than Python, you should change it in the template.
            vim.api.nvim_create_user_command("Nb", function(opts)
                new_notebook(opts.args)
            end, {
                nargs = 1,
                complete = "file",
            })
        end,
    },
}
