vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>uq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window nav
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Quickfix
vim.keymap.set("n", "<leader>uq", vim.diagnostic.setloclist, { desc = "[S]how diagnostic [Q]uickfix list" })
vim.keymap.set("n", "[q", ":cprev<cr>", { desc = "Quickfix previous" })
vim.keymap.set("n", "]q", ":cnext<cr>", { desc = "Quickfix next" })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[S]how diagnostic [E]rror messages" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Buffer nav
vim.keymap.set("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "d<tab>", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Tab nav
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Prev tab" })
vim.keymap.set("n", "]<tab>", "<cmd>tabNext<cr>", { desc = "Next tab" })

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

-- Others
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "ThePrimeLord" })

-- Break visual selection lines by .
vim.keymap.set("v", "<localleader>lf", [[:s/\([.]\)/\1\r/g]], { desc = "Break lines by ." })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

function _G.operator_replace_with_yank(type)
    if type == "line" then
        vim.cmd("normal! '[V']\"rdP")
    elseif type == "char" then
        vim.cmd('normal! `[v`]"rdP')
    else
        vim.notify("Block mode not supported.")
    end
end

vim.keymap.set({ "n", "o" }, "<leader>p", "<cmd>set operatorfunc=v:lua.operator_replace_with_yank<CR>g@", { desc = "Replace with yank" })

vim.keymap.set("n", "<leader>cr", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "IncRename" })

local cmd_in_tmux_window = function(cmd)
    if vim.fn.exists("$TMUX") then
        vim.fn.system("tmux neww -S -n " .. vim.fn.expand("%:t"):gsub("%p", "_") .. "\\; send-keys '" .. cmd .. "' C-m;")
    else
        vim.notify("Outside TMUX")
    end
end

vim.keymap.set("n", "<localleader>fp", function()
    local cmd = vim.fn.expandcmd("python %:.")
    cmd_in_tmux_window(cmd)
end, { desc = "Run python file in new TMUX window" })

vim.keymap.set("n", "<localleader>fc", function()
    local prog = vim.fn.expand("%:e") == "c" and "gcc " or "g++ "
    local cmd = prog .. vim.fn.expandcmd("%:. -o %:t:r")
    cmd_in_tmux_window(cmd)
end, { desc = "Run gcc/g++ file in new TMUX window" })

local open_repl = function(prog)
    if vim.env.TMUX == nil then
        vim.cmd("vsplit | terminal " .. prog)
    else
        vim.fn.system("tmux splitw -hd\\; send-keys -t :.2 '" .. prog .. "' C-m;" )
    end
end

local repl_keymap = function(exe)
    local prog = vim.fn.exepath(exe)
    if prog == "" then
        return
    end
    vim.keymap.set("n", "<leader>v" .. exe:sub(1, 1), function()
        open_repl(prog)
    end, { desc = exe:upper() .. " REPL" })
end

repl_keymap("python")
repl_keymap("ipython")

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
