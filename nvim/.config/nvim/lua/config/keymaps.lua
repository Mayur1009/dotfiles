-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Norwegian keyboard layout
vim.keymap.set({ "n", "o", "v", "x" }, "ø", "[", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "æ", "]", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "Ø", "{", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "Æ", "}", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "-", "/", { remap = true })

vim.keymap.set({ "n", "o", "v", "x" }, "[ø", "[[", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "]æ", "]]", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "gø", "g[", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "gæ", "g]", { remap = true })

vim.keymap.set({ "n", "o", "v", "x" }, "gØ", "g{", { remap = true })
vim.keymap.set({ "n", "o", "v", "x" }, "gÆ", "g}", { remap = true })

-- Open Terminals in split
local split_term = function(prog)
  if vim.fn.exists("$TMUX") then
    vim.fn.system("tmux splitw -h -d \\; send-keys -t.{next} " .. prog .. " C-m;")
  else
    vim.cmd(":vsplit term://" .. prog)
  end
end

vim.keymap.set("n", "<leader>vt", "<cmd>vsplit term://$SHELL<cr>", { desc = "Terminal: Shell" })
vim.keymap.set("n", "<leader>vp", function()
  split_term("python")
end, { desc = "Terminal: python" })
vim.keymap.set("n", "<leader>vr", function()
  split_term("R")
end, { desc = "Terminal: R" })
vim.keymap.set("n", "<leader>vi", function()
  split_term("ipython")
end, { desc = "Terminal: ipython" })

-- Run cmd on file in new tmux window named `file_name`. Assume always inside TMUX
local cmd_in_tmux_window = function(cmd)
  if vim.fn.exists("$TMUX") then
    vim.fn.system("tmux neww -S -n " .. vim.fn.expand("%:t"):gsub("%p", "_") .. "\\; send-keys '" .. cmd .. "' C-m;")
  else
    vim.notify("Outside TMUX")
  end
end

vim.keymap.set("n", "<localleader>fp", function()
  local cmd = "python " .. vim.fn.expand("%")
  cmd_in_tmux_window(cmd)
end, { desc = "Run python file in new TMUX window" })

vim.keymap.set("n", "<localleader>fc", function()
  local ext = vim.fn.expand("%:e")
  local cmd = ext == "c" and "gcc " or "g++ " .. vim.fn.expand("%") .. " -o " .. vim.fn.expand("%:t:r")
  cmd_in_tmux_window(cmd)
end, { desc = "Run gcc/g++ file in new TMUX window" })

----------------------------------------------
vim.keymap.del("n", "<leader>bd")
