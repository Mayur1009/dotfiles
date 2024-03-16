-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = "-"
-- vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_method = "sioyek"
vim.g.python3_host_prog = vim.fn.expand("/Users/mayurks/envs/neovim/bin/python3")
vim.g.python_host_prog = vim.fn.expand("/Users/mayurks/envs/neovim/bin/python")

vim.o.conceallevel = 0
vim.o.textwidth = 160
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.pumblend = 4
vim.o.pumheight = 15
vim.o.scrolloff = 5
vim.o.mousescroll = "ver:1,hor:2"

if vim.g.neovide then
    vim.o.guifont = "MapleMono Nerd Font:h14"
    vim.o.linespace = 1.2
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_trail_size = 0.1
end
