return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {
                    virt_text_pos = "eol",
                },
            },
        },
        config = function()
            local dap_icons = {
                Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
                Breakpoint = " ",
                BreakpointCondition = " ",
                BreakpointRejected = { " ", "DiagnosticError" },
                LogPoint = ".>",
            }
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            for name, sign in pairs(dap_icons) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] })
            end

            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP: UI Toggle" })
            vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "DAP: UI Eval" })
        end,
        keys = {
            "<leader>du",
            "<leader>de",
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap-python",
            "rcarriga/cmp-dap",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            local dap = require("dap")
            local dap_py = require("dap-python")

            require("cmp").setup({
                enabled = function()
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
                end,
            })

            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" },
                },
            })

            local path = require("mason-registry").get_package("debugpy"):get_install_path()
            dap_py.setup(path .. "/venv/bin/python")
            table.insert(dap.configurations.python, {
                console = "integratedTerminal",
                name = "My custom Launch file configuration",
                program = "${file}",
                request = "launch",
                type = "python",
                justMyCode = "false",
                logToFile = "true",
                stopOnEntry = "true",
            })

            if not dap.adapters["codelldb"] then
                require("dap").adapters["codelldb"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "codelldb",
                        args = {
                            "--port",
                            "${port}",
                        },
                    },
                }
            end
            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "Launch file",
                        program = function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                        end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "DAP: Set Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue/Start" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step into" })
            vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step over" })
            vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: Step out" })
            vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "DAP: Pause" })
            vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: Terminate" })
            vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
            vim.keymap.set("n", "<leader>ds", dap.session, { desc = "DAP: Session" })

            vim.keymap.set("n", "<F6>", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            vim.keymap.set("n", "<F7>", dap.step_out, { desc = "DAP: Step out" })
            vim.keymap.set("n", "<F8>", dap.continue, { desc = "DAP: Continue/Start" })
            vim.keymap.set("n", "<S-F8>", dap.terminate, { desc = "DAP: Terminate" })
            vim.keymap.set("n", "<F9>", dap.step_over, { desc = "DAP: Step over" })
            vim.keymap.set("n", "<S-F9>", dap.step_into, { desc = "DAP: Step into" })
        end,
        keys = {
            "<leader>db",
            "<leader>dB",
            "<leader>dc",
            "<leader>di",
            "<leader>do",
            "<leader>dO",
            "<leader>dp",
            "<leader>dt",
            "<leader>dC",
            "<leader>ds",
            "<F6>",
            "<F7>",
            "<F8>",
            "<S-F8>",
            "<F9>",
            "<S-F9>",
        },
    },
}
