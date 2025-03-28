return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      statuscolumn = {
        left = { "mark", "git" }, -- priority of signs on the left (high to low)
        right = { "sign", "fold" }, -- priority of signs on the right (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = true, -- use Git Signs hl for fold icons
        },
      },
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
          grep = {
            hidden = true,
          },
        },
      },
    },
    keys = {
      { "<leader>,", false },
      {
        "d<Tab>",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
    },
  },
  { "akinsho/bufferline.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "echasnovski/mini.tabline", opts = {} },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
      require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
        ["<C-g>"] = {
          function(cmp)
            cmp.show({ providers = { "snippets" } })
          end,
          "fallback",
        },
      },
      sources = {
        providers = {
          path = {
            opts = {
              show_hidden_files_by_default = true,
              get_cwd = function(ctx)
                return vim.fn.getcwd()
              end,
            },
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 0,
            async = true,
          },
        },
      },
      completion = {
        ghost_text = { enabled = false },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
            align_to = "kind_icon",
          },
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
    },
  },
  -- LSP keymaps
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gR", vim.lsp.buf.rename, desc = "LSP Rename" }
      keys[#keys + 1] = { "gF", vim.lsp.buf.format, desc = "LSP Format" }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          keys = {
            {
              "<leader>co",
              false,
            },
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      popupmenu = {
        enabled = false,
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        hide_during_completion = false,
        keymap = {
          dismiss = "<M-e>",
          next = "<M-n>",
          prev = "<M-p>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
      ensure_installed = {
        "cuda",
      },
    },
  },
}
