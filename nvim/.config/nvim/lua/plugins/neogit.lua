return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim",
    },
    keys = {
      {"<leader>gn", ":Neogit<CR>",  desc = "Neogit" },
      { "<leader>gv", desc="Git Diffview Toggle" },
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true,
        },
      })

      local diffview_open = false
      vim.keymap.set("n", "<leader>gv", function()
        local cmd = diffview_open and ":DiffviewClose" or ":DiffviewOpen"
        diffview_open = not diffview_open
        vim.cmd(cmd)
      end, { desc = "Git Diffview Toggle" })
    end,
  },
}
