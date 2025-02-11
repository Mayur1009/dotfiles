-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.python3_host_prog = vim.fn.expand("$HOME/.nvim_venv/bin/python3")
vim.g.python_host_prog = vim.fn.expand("$HOME/.nvim_venv/bin/python")

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Work or personal laptop??
vim.g.is_work_laptop = vim.uv.os_uname().sysname == "Darwin"

-- Coding target
vim.g.code_target = "tmux"

-- Fix markdown indentation settings
-- vim.g.markdown_recommended_style = 0
-- vim.g.markdown_folding = 1

local opt = vim.opt

opt.autowrite = true
opt.breakindent = true
opt.breakindentopt = "shift:2,sbr"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0
opt.confirm = true
opt.cpoptions:append("n")
opt.cursorline = true
opt.expandtab = true
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepprg = "rg --vimgrep"
opt.hlsearch = true
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- Preview incremental substitute
opt.linebreak = true
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣", --[[eol = ""]]
}
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 6 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ c = true, C = true })
opt.showbreak = "↪"
opt.showmode = false -- Don't show mode since we have a statusline
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
opt.title = true
opt.undofile = true
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wrap = true -- Disable line wrap

vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
opt.fillchars = {
    foldopen = "",
    foldclose = "",
}

opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20-rCursor,v:vCursor"

vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang", [".*/kitty/.+%.conf"] = "bash", ["%.env%.[%w_.-]+"] = "sh" },
    extension = {
        zsh = "sh",
        sh = "sh",
    },
    filename = {
        [".zshrc"] = "sh",
        [".zshenv"] = "sh",
    },
})
