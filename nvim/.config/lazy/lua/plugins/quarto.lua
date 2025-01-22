local nmap = function(key, effect, desc)
  vim.keymap.set("n", key, effect, { desc = desc, silent = true, noremap = true })
end

local vmap = function(key, effect, desc)
  vim.keymap.set("v", key, effect, { desc = desc, silent = true, noremap = true })
end

local imap = function(key, effect, desc)
  vim.keymap.set("i", key, effect, { desc = desc, silent = true, noremap = true })
end

return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown" },
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
        opts = {
          lsp = {
            diagnostic_update_events = { "BufWritePost", "CompleteDone", "TextChangedI" },
          },
          buffers = {
            set_filetype = true,
            write_to_disk = true,
          },
          handle_leading_whitespace = true,
        },
      },
    },
    config = function()
      require("quarto").setup({
        codeRunner = {
          enabled = true,
          default_method = "slime",
          ft_runners = {
            python = "molten",
          },
        },
      })

      local quarto = require("quarto")
      local runner = require("quarto.runner")

      nmap("<localleader>qa", ":QuartoActivate<CR>", "Activate")
      nmap("<localleader>qp", quarto.quartoPreview, "Preview")
      nmap("<localleader>qq", quarto.quartoClosePreview, "Close Preview")
      nmap("<localleader>qh", ":QuartoHelp ", "Help")
      nmap("<localleader>qe", ":lua require'otter'.export()<cr>", "Export")
      nmap("<localleader>qE", ":lua require'otter'.export(true)<cr>", "Export Overwrite")

      nmap("<localleader>cr", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
      nmap("<localleader>cp", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")

      nmap("<M-r>", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
      nmap("<M-e>", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")
      imap("<M-r>", "<esc>o```{r}<cr>```<esc>O", "Code cell [R]")
      imap("<M-e>", "<esc>o```{python}<cr>```<esc>O", "Code cell [P]ython")

      nmap("<M-CR>", function()
        runner.run_cell()
        vim.cmd("normal ]o")
      end, "Run and next cell")
      nmap("<localleader>qr", runner.run_cell, "Run cell")
      nmap("<localleader>qA", runner.run_all, "Run All")
      nmap("<localleader>ql", runner.run_line, "Run line")
      vmap("<localleader>qr", runner.run_range, "Run range")
    end,
  },
}
