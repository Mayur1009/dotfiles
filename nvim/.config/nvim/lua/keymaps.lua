-- -- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>se", vim.diagnostic.open_float, { desc = "[S]how diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>sq", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

vim.keymap.set("n", "<leader>bd", ":bd<cr>", { desc = "Buffer Delete" })

-- Toggle Diagnostics
vim.keymap.set("n", "<leader>td", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
    { desc = "[T]oggle [D]iagnostics" })


vim.keymap.set("n", "<leader>Tt", "<cmd>vsplit term://fish<cr>", { desc = "Terminal: Shell(fish)" })

local split_term = function(prog)
    local command = vim.fn.exists("$TMUX") and ":!tmux splitw -h -d \\; send-keys -t.{next} " .. prog .. " C-m;" or
        ":vsplit term://" .. prog
    vim.cmd(command)
end

vim.keymap.set("n", "<leader>Tp", function() split_term("python") end, { desc = "Terminal: python" })
vim.keymap.set("n", "<leader>Tr", function() split_term("R") end, { desc = "Terminal: R" })
vim.keymap.set("n", "<leader>Ti", function() split_term("ipython") end, { desc = "Terminal: ipython" })

vim.keymap.set("n", "[q", ":cprev<cr>", { desc = "Quickfix previous" })
vim.keymap.set("n", "]q", ":cnext<cr>", { desc = "Quickfix next" })

vim.keymap.set("i", "jk", "<Esc>")

-- Toggle buffer lock
vim.keymap.set("n", "<leader>tl", function()
    vim.bo.modifiable = not vim.bo.modifiable
end, { desc = "Toggle file [l]ock" })

-- Run python file in new tmux window named `file_name`. Assume always inside TMUX
vim.keymap.set("n", "<leader>wp", function()
    vim.cmd(":!tmux neww -S -n " ..
        vim.fn.expand("%:t"):gsub("%p", "_") .. "\\; send-keys 'python " .. vim.fn.expand("%:p") .. "' C-m;")
end, { desc = "Run Current python file in new TMUX window" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete to void" })
vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Replace without changing register" })

-- Norwegian keybord layout
vim.keymap.set("n", "ø", "[", { remap = true })
vim.keymap.set("n", "æ", "]", { remap = true })
vim.keymap.set("n", "Ø", "{", { remap = true })
vim.keymap.set("n", "Æ", "}", { remap = true })
vim.keymap.set("n", "-", "/", { remap = true })
