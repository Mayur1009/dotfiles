vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.python3_host_prog = vim.fn.expand("$HOME/.nvim_venv/bin/python3")
vim.g.python_host_prog = vim.fn.expand("$HOME/.nvim_venv/bin/python")
vim.g.undotree_SetFocusWhenToggle = true
vim.g.autoformat = false

vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.foldlevel = 99
vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.wrap = true
vim.opt.smoothscroll = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "
vim.opt.breakindent = true
vim.opt.title = true
vim.opt.conceallevel = 2
vim.opt.concealcursor = "n"
vim.opt.virtualedit = "block"

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"


vim.filetype.add({
    pattern = {
        [".*/waybar/config"] = "jsonc",
        [".*/mako/config"] = "dosini",
        [".*/kitty/.+%.conf"] = "bash",
        [".*/hypr/.+%.conf"] = "hyprlang",
        ["%.env%.[%w_.-]+"] = "sh",
        ["%.envrc"] = "sh",
    },
})
