-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

vim.keymap.set({ "n", "i", "v" }, "<S-ScrollWheelDown>", "<ScrollWheelRight>")
vim.keymap.set({ "n", "i", "v" }, "<S-ScrollWheelUp>", "<ScrollWheelLeft>")

wk.register({ ["<localleader>t"] = { name = "+terminals" } })
vim.keymap.set({ "n" }, "<localleader>tr", "<CMD>vsplit term://R<CR>", { desc = "[t]erminal: R" })
vim.keymap.set({ "n" }, "<localleader>ti", "<CMD>vsplit term://ipython<CR>", { desc = "[t]erminal: ipython" })
vim.keymap.set({ "n" }, "<localleader>tp", "<CMD>vsplit term://python<CR>", { desc = "[t]erminal: python" })
vim.keymap.set({ "n" }, "<localleader>tt", "<CMD>vsplit term://$SHELL<CR>", { desc = "[t]erminal: shell" })
