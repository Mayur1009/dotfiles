vim.b.slime_cell_delimiter = "```"

vim.cmd("set filetype=markdown")

-- wrap text, but by word no character
-- indent the wrappped line
-- vim.wo.wrap = true
-- vim.wo.linebreak = true
-- vim.wo.breakindent = true
-- vim.wo.showbreak = "|"

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- don't run vim ftplugin on top
-- vim.api.nvim_buf_set_var(0, "did_ftplugin", true)
