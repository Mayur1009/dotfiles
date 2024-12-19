-- -- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>te", vim.diagnostic.open_float, { desc = "[S]how diagnostic [E]rror messages" })

-- Quickfix
vim.keymap.set("n", "<leader>tq", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [Q]uickfix list" })
vim.keymap.set("n", "[q", ":cprev<cr>", { desc = "Quickfix previous" })
vim.keymap.set("n", "]q", ":cnext<cr>", { desc = "Quickfix next" })

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

-- Buffer nav
vim.keymap.set("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- vim.keymap.set("n", "d<tab>", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

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

-- Toggle Diagnostics
-- vim.keymap.set("n", "<leader>td", function()
--     vim.diagnostic.enable(not vim.diagnostic.is_enabled())
-- end, { desc = "[T]oggle [D]iagnostics" })

-- Toggle buffer lock
vim.keymap.set("n", "<leader>ul", function()
    vim.bo.modifiable = not vim.bo.modifiable
end, { desc = "Toggle file [l]ock" })

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
        vim.fn.system(
            "tmux neww -S -n " .. vim.fn.expand("%:t"):gsub("%p", "_") .. "\\; send-keys '" .. cmd .. "' C-m;"
        )
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

vim.keymap.set("n", "<leader>ct", function ()
    if vim.g.code_target == "kitty" then
        vim.g.code_target = "tmux"
    else
        vim.g.code_target = "kitty"
    end
    vim.g.slime_target = vim.g.code_target
end, {desc = "Switch g:code_target betwn kitty and tmux"})

-- Others
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

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
