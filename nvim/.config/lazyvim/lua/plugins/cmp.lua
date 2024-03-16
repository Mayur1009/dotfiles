-- local function dump(o, indent)
--     if type(o) == "table" then
--         local s = "{\n"
--         for k, v in pairs(o) do
--             if type(k) ~= "number" then
--                 k = '"' .. k .. '"'
--             end
--             s = s .. "\t[" .. k .. "] = " .. dump(v) .. ",\n"
--         end
--         return s .. "\n} "
--     else
--         return tostring(o)
--     end
-- end
function rPrint(s, l, i) -- recursive Print (structure, limit, indent)
    l = l or 100
    i = i or "" -- default item limit, indent string
    if l < 1 then
        print("ERROR: Item limit reached.")
        return l - 1
    end
    local ts = type(s)
    if ts ~= "table" then
        print(i, ts, s)
        return l - 1
    end
    print(i, ts) -- print "table"
    for k, v in pairs(s) do -- print "[KEY] VALUE"
        l = rPrint(v, l, i .. "\t[" .. tostring(k) .. "]")
        if l < 0 then
            break
        end
    end
    return l
end

return {
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            return {}
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-emoji" },
            { "kdheepak/cmp-latex-symbols" },
            { "jmbuhr/cmp-pandoc-references" },
            { "jmbuhr/otter.nvim" },
            {
                "micangl/cmp-vimtex",
                opts = {},
            },
        },
        opts = function(_, opts)
            local luasnip = require("luasnip")
            local cmp = require("cmp")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
            luasnip.filetype_extend("quarto", { "markdown" })
            luasnip.filetype_extend("rmarkdown", { "markdown" })

            table.insert(opts.sources, 2, {
                name = "otter",
                group_index = 1,
                priority = 100,
            })
            table.insert(opts.sources, 3, {
                name = "vimtex",
                group_index = 1,
                priority = 100,
            })
            table.insert(opts.sources, { name = "nvim_lsp_signature_help", group_index = 1 })
            table.insert(opts.sources, { name = "latex_symbols", group_index = 1 })
            table.insert(opts.sources, { name = "pandoc_references", group_index = 1 })
            table.insert(opts.sources, { name = "emoji", group_index = 1 })

            opts.experimental = {
                ghost_text = false,
            }

            opts.view = {
                entries = {
                    name = "custom",
                    selection_order = "near_cursor",
                },
            }

            opts.window = {
                -- completion = {
                --     completeopt = "menu,menuone,noselect",
                --     winhighlight = "Normal:Pmenu,CursorLine:MiniStatuslineModeInsert",
                -- },
                -- completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            }

            opts.preselect = "None"

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<C-d>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    else
                        fallback()
                    end
                end, { "i" }),

                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            cmp.abort()
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                }),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
                        cmp.confirm()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- this way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
            -- print(rPrint(opts.mapping))
        end,
    },
}
