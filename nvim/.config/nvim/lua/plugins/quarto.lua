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
            local wk = require("which-key")
            wk.register({
                ["<localleader>q"] = {
                    name = "quarto",
                    a = { ":QuartoActivate<CR>", "Activate" },
                    p = { quarto.quartoPreview, "Preview" },
                    q = { quarto.quartoClosePreview, "Close Preview" },
                    h = { ":QuartoHelp ", "Help" },
                    e = { ":lua require'otter'.export()<cr>", "Export" },
                    E = { ":lua require'otter'.export(true)<cr>", "Export Overwrite" },
                    t = { show_table, "Show Table" },
                },
                ["<localleader>r"] = {
                    name = "run",
                    c = { runner.run_cell, "Cell" },
                    a = { runner.run_above, "Cell and Above" },
                    A = { runner.run_all, "All Cells" },
                    l = { runner.run_line, "Line" },
                    R = {
                        function()
                            runner.run_all(true)
                        end,
                        "All Cells of All Languages",
                    },
                },
            })
            vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Run visual range" })
            vim.keymap.set({ "n", "i" }, "<localleader>æ", runner.run_cell, { desc = "Run cell" })
            vim.keymap.set({ "n", "i" }, "<localleader>0", runner.run_cell, { desc = "Run cell" })
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

            require("which-key").register({
                ["<localleader>s"] = {
                    name = "+slime",
                    m = { mark_terminal, "mark terminal" },
                    s = { set_terminal, "set terminal" },
                    t = { toggle_slime_tmux_nvim, "toggle slime nvim/tmux" },
                },
                ["<localleader>s<cr>"] = { send_cell, "Slime Send Code chunk" },
                ["<M-CR>"] = { send_cell, "Slime Send Code chunk" },
                ["<C-CR>"] = {
                    function()
                        send_cell()
                    end,
                    "run code",
                },
            })
            vim.keymap.set({ "i" }, "<M-cr>", "<esc><Plug>SlimeSendCell<cr>i", { silent = true, noremap = true, desc = "send code chunk" })
            vim.keymap.set({ "v" }, "<M-cr>", "<Plug>SlimeRegionSend", { silent = true, noremap = true, desc = "send code chunk" })
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
