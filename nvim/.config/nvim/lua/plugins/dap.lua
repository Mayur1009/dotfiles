---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
    local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
        if config.type and config.type == "java" then
            ---@diagnostic disable-next-line: return-type-mismatch
            return new_args
        end
        return require("dap.utils").splitstr(new_args)
    end
    return config
end

return {
    {
        "mfussenegger/nvim-dap",
        cond = not vim.g.vscode,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
            {
                "jbyuki/one-small-step-for-vimkind",
                config = function()
                    local dap = require("dap")
                    dap.adapters.nlua = function(callback, conf)
                        local adapter = {
                            type = "server",
                            host = conf.host or "127.0.0.1",
                            port = conf.port or 8086,
                        }
                        if conf.start_neovim then
                            local dap_run = dap.run
                            dap.run = function(c)
                                adapter.port = c.port
                                adapter.host = c.host
                            end
                            require("osv").run_this()
                            dap.run = dap_run
                        end
                        callback(adapter)
                    end
                    dap.configurations.lua = {
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Run this file",
                            start_neovim = {},
                        },
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Attach to running Neovim instance (port = 8086)",
                            port = 8086,
                        },
                    }
                end,
            },
        },

        -- stylua: ignore
        keys = {
            { "<localleader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<localleader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<localleader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
            { "<localleader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
            { "<localleader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<localleader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
            { "<localleader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<localleader>dj", function() require("dap").down() end, desc = "Down" },
            { "<localleader>dk", function() require("dap").up() end, desc = "Up" },
            { "<localleader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<localleader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<localleader>dO", function() require("dap").step_over() end, desc = "Step Over" },
            { "<localleader>dP", function() require("dap").pause() end, desc = "Pause" },
            { "<localleader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<localleader>ds", function() require("dap").session() end, desc = "Session" },
            { "<localleader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<localleader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
        },

        config = function()
            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            -- setup dap config by VsCode launch.json file
            local vscode = require("dap.ext.vscode")
            local json = require("plenary.json")
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        cond = not vim.g.vscode,
        dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
            { "<localleader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
            { "<localleader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {},
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },

    {
        "mfussenegger/nvim-dap",
        cond = not vim.g.vscode,
        opts = function()
            local dap = require("dap")
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
                        pid = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        cond = not vim.g.vscode,
        -- stylua: ignore
        keys = {
            { "<localleader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
            { "<localleader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
        },
        config = function()
            local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
            require("dap-python").setup(root .. "/packages/debugpy/venv/bin/python")
        end,
    },
}
