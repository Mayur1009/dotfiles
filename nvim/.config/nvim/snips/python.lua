local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
return {
    s(
        "dbg",
        fmt("print(f'{{{}=}}'){}", {i(1), i(0)})
    )
}
