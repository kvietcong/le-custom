-- Snippets
local luasnip = require("luasnip")
local lf = require("le/libf")

local s = luasnip.snippet
-- local sn = luasnip.snippet_node
-- local isn = luasnip.indent_snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
-- local d = luasnip.dynamic_node
-- local r = luasnip.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local fmt = require("luasnip.extras.fmt").fmt
-- local m = require("luasnip.extras").m
-- local lambda = require("luasnip.extras").l

vim.keymap.set("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.keymap.set("i", "<C-u>", require("luasnip.extras.select_choice"), {})
vim.keymap.set("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.keymap.set("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.keymap.set("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

luasnip.add_snippets("all", {
    s("@@", {
        c(1, {
            f(function() return lf.get_date()["my-date"] end),
            f(function() return "D"..(lf.get_date()["day"]) end),
            f(function() return "W"..(lf.get_date()["week"]) end),
            f(function() return "H"..(lf.get_date()["hour"]) end),
            f(function() return "M"..(lf.get_date()["minute"]) end),
            f(function() return "S"..(lf.get_date()["second"]) end),
        }),
    }),
}, {
    key = "general",
})

luasnip.add_snippets("markdown", {
    s("@meta", {
        t("---"),
        t({"", "aliases: "}), c(1, {t("~"), {t({"", "- "}), i(1)}}),
        -- TODO: Weird how I can't store function node in a local variable and reuse
        t({"", "created: "}), f(function() return lf.get_date()["my-date"] end),
        t({"", "edited: "}), f(function() return lf.get_date()["my-date"] end),
        t({"", "tags: "}), c(2, {t("~"), {t({"", "- "}), i(1)}}),
        t({"", "---"}),
    }),
    s("@today", f(function() return lf.get_date()["my-date"] end)),
    s("@quick-content", {
        t("[["), i(1, "Title"), t(" ~ "), i(2, "Originators"), t("]]"),
    }),
}, {
    key = "note-taking",
})

return luasnip
