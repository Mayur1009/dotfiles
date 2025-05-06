vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

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
