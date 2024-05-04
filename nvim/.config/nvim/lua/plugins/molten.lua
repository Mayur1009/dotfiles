local nmap = function(key, effect, desc)
    vim.keymap.set("n", key, effect, { desc = desc, silent = true, noremap = true })
end

local vmap = function(key, effect, desc)
    vim.keymap.set("v", key, effect, { desc = desc, silent = true, noremap = true })
end

local imap = function(key, effect, desc)
    vim.keymap.set("i", key, effect, { desc = desc, silent = true, noremap = true })
end

return {
    {
        "benlubas/molten-nvim",
        dependencies = {
            {
                "3rd/image.nvim",
                opts = {
                    backend = "kitty",
                    integrations = {
                        markdown = {
                            enabled = true,
                            -- clear_in_insert_mode = false,
                            -- download_remote_images = true,
                            only_render_image_at_cursor = true,
                            filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
                        },
                        neorg = {
                            enabled = true,
                            clear_in_insert_mode = false,
                            download_remote_images = true,
                            only_render_image_at_cursor = false,
                            filetypes = { "norg" },
                        },
                    },
                    max_width = 100,
                    max_height = 50,
                    max_width_window_percentage = math.huge,
                    max_height_window_percentage = math.huge,
                    window_overlap_clear_enabled = true,
                    window_overlap_clear_ft_ignore = { "" },
                    -- editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
                    -- tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
                },
            },
            {
                "GCBallesteros/jupytext.nvim",
                config = function()
                    require("jupytext").setup({
                        -- style = "markdown",
                        -- output_extension = "md",
                        -- force_ft = "markdown",
                        style = "quarto",
                        output_extension = "qmd",
                        force_ft = "quarto",
                    })
                end,
            },
            {
                "willothy/wezterm.nvim",
                config = true,
            },
        },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.auto_image_popup = true
            vim.g.molten_auto_open_output = false
            vim.g.molten_enter_output_behavior = "open_and_enter"
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_crop_border = false
            vim.g.molten_output_show_more = true
            vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
            vim.g.molten_output_win_max_height = 30
            vim.g.molten_tick_rate = 150
            vim.g.molten_use_border_highlights = true
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
            vim.g.molten_wrap_output = true

            vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { link = "ErrorMsg" })
            vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { link = "Character" })
            vim.api.nvim_set_hl(0, "MoltenOutputWin", { bg = "#0c0c0c" })
            vim.api.nvim_set_hl(0, "MoltenCell", { bg = "#161616" })
        end,
        config = function()
            nmap("<leader>mi", ":MoltenInit<CR>", "Molten Init")
            nmap("<leader>mq", ":MoltenDeinit<CR>", "Molten DeInit")
            nmap("<leader>mI", ":MoltenInfo<CR>", "Molten Info")
            nmap("<leader>md", ":MoltenDelete<CR>", "Molten Delete")
            nmap("<leader>ml", ":MoltenEvaluateLine<CR>", "Molten Evaluate Line")
            nmap("<leader>mr", ":MoltenReevaluateCell<CR>", "Molten Reevaluate Cell")
            nmap("<leader>me", ":MoltenEvaluateOperator<CR>", "Molten Evaluate Operator")
            nmap("<leader>mh", ":MoltenHideOutput<CR>", "Molten Hide Output")
            nmap("<leader>ms", ":MoltenShowOutput<CR>", "Molten Show Output")
            nmap("<leader>mo", ":noautocmd MoltenEnterOutput<CR>", "Molten Enter Output Window")
            nmap("<leader>mx", ":MoltenExportOutput<CR>", "Molten Export Output")
            nmap("<leader>mX", ":MoltenImportOutput<CR>", "Molten Import Output")
            nmap("<leader>mb", ":MoltenOpenInBrowser<CR>", "Molten Open In Browser")
            nmap("<leader>mp", ":MoltenImagePopup<CR>", "Molten Image Popup")

            vmap("<localleader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv", "Evaluate Visual Selection")

            require("which-key").register({
                ["<leader>m"] = { name = "+Molten", _ = "which_key_ignore" },
            })

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
                pattern = { "*.ipynb" },
                callback = imb,
            })

            -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "*.ipynb" },
                callback = function(e)
                    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
                        imb(e)
                    end
                end,
            })

            -- automatically export output chunks to a jupyter notebook on write
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.ipynb" },
                callback = function()
                    if require("molten.status").initialized() == "Molten" then
                        vim.cmd("MoltenExportOutput!")
                    end
                end,
            })
        end,
    },
}
