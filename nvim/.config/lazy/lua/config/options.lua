-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.is_work_laptop = vim.uv.os_uname().sysname == "Darwin"
vim.g.maplocalleader = ","
vim.g.autoformat = false
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.python3_host_prog = vim.fn.expand("$HOME/.nvim_venv/bin/python3")
vim.g.python_host_prog = vim.fn.expand("$HOME/.nvim_venv/bin/python")
vim.g.vimtex_view_method = vim.g.is_work_laptop and "skim" or "zathura"

local opt = vim.opt

opt.shiftwidth = 4
opt.tabstop = 4

opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣", --[[eol = ""]]
}

opt.showbreak = "↪"
opt.wrap = true
opt.breakindent = true

opt.inccommand = "split"
