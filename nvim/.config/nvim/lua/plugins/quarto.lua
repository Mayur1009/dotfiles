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
        "quarto-dev/quarto-nvim",
        ft = { "quarto", "markdown" },
        dependencies = {
            "jmbuhr/otter.nvim",
            "jpalardy/vim-slime",
            "benlubas/molten-nvim",
        },
        config = function()
            require("quarto").setup({
                codeRunner = {
                    enable = true,
                    default_method = "molten",
                    ft_runners = {
                        r = "slime",
                    },
                },
            })

            local function show_table()
                local node = vim.treesitter.get_node({ ignore_injections = false })
                local text = vim.treesitter.get_node_text(node, 0)
                local cmd = [[call slime#send("DT::datatable(]] .. text .. [[)" . "\r")]]
                vim.cmd(cmd)
            end

            local quarto = require("quarto")
            local runner = require("quarto.runner")

            nmap("<leader>qa", ":QuartoActivate<CR>", "Activate")
            nmap("<leader>qp", quarto.quartoPreview, "Preview")
            nmap("<leader>qq", quarto.quartoClosePreview, "Close Preview")
            nmap("<leader>qh", ":QuartoHelp ", "Help")
            nmap("<leader>qe", ":lua require'otter'.export()<cr>", "Export")
            nmap("<leader>qE", ":lua require'otter'.export(true)<cr>", "Export Overwrite")
            nmap("<leader>qt", show_table, "Show Table")

            nmap("<leader>cc", runner.run_cell, "Run Cell")
            nmap("<leader>ca", runner.run_above, "Run Cell and Above")
            nmap("<leader>cA", runner.run_all, "Run All Cells")
            nmap("<leader>cl", runner.run_line, "Run Line")
            nmap("<leader>cC", function()
                runner.run_all(true)
            end, "All Cells of All Languages")
            nmap("<leader><CR>", function()
                runner.run_cell()
                vim.cmd("normal ]b")
            end, "Run Cell and move to next cell")

            vmap("<leader><CR>", runner.run_range, "Run Visual range")
        end,
    },
    {
        "jmbuhr/otter.nvim",
        lazy = true,
        opts = {
            buffers = {
                set_filetype = true,
            },
        },
    },
    {
        "jpalardy/vim-slime",
        init = function()
            vim.b["quarto_is_" .. "python" .. "_chunk"] = false
            Quarto_is_in_python_chunk = function()
                require("otter.tools.functions").is_otter_language_context("python")
            end

            vim.cmd([[
            let g:slime_dispatch_ipython_pause = 100
            function SlimeOverride_EscapeText_quarto(text)
            call v:lua.Quarto_is_in_python_chunk()
            if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
            return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
            else
            if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
            return [a:text, "\n"]
            else
            return [a:text]
            end
            end
            endfunction
            ]])

            local function mark_terminal()
                vim.g.slime_last_channel = vim.b.terminal_job_id
                vim.print(vim.g.slime_last_channel)
            end

            local function set_terminal()
                vim.b.slime_config = { jobid = vim.g.slime_last_channel }
            end

            local function toggle_slime_tmux_nvim()
                if vim.g.slime_target == "tmux" then
                    pcall(function()
                        vim.b.slime_config = nil
                        vim.g.slime_default_config = nil
                    end)
                    -- slime, neovvim terminal
                    vim.g.slime_target = "neovim"
                    vim.g.slime_bracketed_paste = 0
                    vim.g.slime_python_ipython = 1
                elseif vim.g.slime_target == "neovim" then
                    pcall(function()
                        vim.b.slime_config = nil
                        vim.g.slime_default_config = nil
                    end)
                    -- -- slime, tmux
                    vim.g.slime_target = "tmux"
                    vim.g.slime_bracketed_paste = 1
                    vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }
                end
            end

            -- slime, neovvim terminal
            vim.g.slime_target = "tmux"
            vim.g.slime_python_ipython = 1

            local function send_cell()
                if vim.b["quarto_is_r_mode"] == nil then
                    vim.cmd([[call slime#send_cell()]])
                    return
                end
                if vim.b["quarto_is_r_mode"] == true then
                    vim.g.slime_python_ipython = 0
                    local is_python = require("otter.tools.functions").is_otter_language_context("python")
                    if is_python and not vim.b["reticulate_running"] then
                        vim.cmd([[call slime#send("reticulate::repl_python()" . "\r")]])
                        vim.b["reticulate_running"] = true
                    end
                    if not is_python and vim.b["reticulate_running"] then
                        vim.cmd([[call slime#send("exit" . "\r")]])
                        vim.b["reticulate_running"] = false
                    end
                    vim.cmd([[call slime#send_cell()]])
                end
            end

            nmap("<leader>qm", mark_terminal, "Slime Mark Terminal")
            nmap("<leader>qs", set_terminal, "Slime Set Terminal")
            nmap("<leader>qT", toggle_slime_tmux_nvim, "Slime Toggle Tmux/Nvim terminal")
            nmap("<leader>q<CR>", send_cell, "Slime Send Code chunk")
            nmap("<C-CR>", send_cell, "Slime Send Code chunk")
            nmap("<M-CR>", function()
                send_cell()
                vim.cmd("normal ]b")
            end, "Slime Send Code chunk and move to next cell")

            imap("<C-CR>", "<esc><Plug>SlimeSendCell<cr>i", "Slime Send Code chunk")
            vmap("<C-CR>", "<Plug>SlimeRegionSend", "Slime Send Code chunk")
        end,
    },
    {
        "HakonHarnes/img-clip.nvim",
        event = "BufEnter",
        opts = {
            filetypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
                quarto = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                    drag_and_drop = {
                        download_images = false,
                    },
                },
            },
        },
    },
}
