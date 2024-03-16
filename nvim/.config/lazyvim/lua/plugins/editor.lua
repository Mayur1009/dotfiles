return {
    {
        "folke/noice.nvim",
        -- enabled = false,

        opts = {
            -- cmdline = {
            --     view = "cmdline",
            -- },
            presets = {
                lsp_doc_border = true,
            },
        },
    },

    {
        "rcarriga/nvim-notify",
        enabled = false,
        opts = {
            render = "compact",
            stages = "fade_in_slide_out",
            timeout = 3500,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.40)
            end,
        },
    },

    -- {
    --     "nvim-treesitter/nvim-treesitter-context",
    --     opts = {
    --         -- max_lines = 6,
    --         separator = "-",
    --     },
    -- },

    {
        "lukas-reineke/headlines.nvim",
        opts = function()
            local opts = {}
            for _, ft in ipairs({ "markdown", "norg", "rmd", "org", "quarto" }) do
                opts[ft] = {
                    headline_highlights = {},
                }
                for i = 1, 6 do
                    local hl = "Headline" .. i
                    vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
                    table.insert(opts[ft].headline_highlights, hl)
                end
            end

            opts.quarto = {
                query = vim.treesitter.query.parse(
                    "markdown",
                    [[
                        (fenced_code_block) @codeblock
                    ]]
                ),
                codeblock_highlight = "CodeBlock",
                treesitter_language = "markdown",
            }
            return opts
        end,
        ft = { "markdown", "norg", "rmd", "org", "quarto" },
    },
}
