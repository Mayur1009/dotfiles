return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      dim_inactive = true,
      lualine_bold = true,
      on_colors = function(colors)
        colors.border = "#ff9e64" --"#565f89"
      end,
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    config = function()
      require("nightfox").setup({
        options = {
          -- dim_inactive = true,
          styles = {
            comments = "italic",
            conditionals = "italic",
            types = "italic,bold",
          },
        },
        groups = {
          carbonfox = {
            Visual = { bg = "#182440" }, -- #224747 #421717, #832d2d, #581e1e, #632f39, #182440
            NormalNC = { bg = "#101010" },
          },
        },
      })
      -- vim.cmd([[colorscheme carbonfox]])
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dim_inactive_windows = true,
        styles = {
          italic = false,
        },
        highlight_groups = {
          Comment = { italic = true },
          Conditionals = { italic = true },
          Keyword = { italic = true },
          Type = { bold = true, italic = true },
          PmenuSel = { fg = "base", bg = "rose" },
          Pmenu = { bg = "highlight_low" },
        },
      })
      -- vim.cmd([[colorscheme rose-pine]])
    end,
  },
}
