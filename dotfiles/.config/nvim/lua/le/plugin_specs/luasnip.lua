local config = function()
    local date = require("date")
    local lf = require("le/libf")
    local luasnip = require("luasnip")

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

    vim.keymap.set("i", "<C-u>", require("luasnip.extras.select_choice"), {})

    local choice_or_nothing = function(keystroke, is_reverse)
        local choice_expression = is_reverse and "<Plug>luasnip-prev-choice"
            or "<Plug>luasnip-next-choice"
        return function()
            return luasnip.choice_active() and choice_expression or keystroke
        end
    end
    vim.keymap.set({ "i", "s" }, "<C-n>", choice_or_nothing("<C-n>"), { expr = true })
    vim.keymap.set(
        { "i", "s" },
        "<C-p>",
        choice_or_nothing("<C-p>", true),
        { expr = true }
    )

    luasnip.config.setup({
        enable_autosnippets = true,
    })

    luasnip.add_snippets("all", {
        s("@@", {
            c(1, {
                f(function()
                    return lf.get_date()["my-date"]
                end),
                f(function()
                    return "D" .. lf.get_date()["day"]
                end),
                f(function()
                    return "W" .. lf.get_date()["week"]
                end),
                f(function()
                    return "H" .. lf.get_date()["hour"]
                end),
                f(function()
                    return "M" .. lf.get_date()["minute"]
                end),
                f(function()
                    return "S" .. lf.get_date()["second"]
                end),
            }),
        }),
    }, {
        key = "general",
    })

    luasnip.add_snippets("markdown", {
        s("@meta", {
            t("---"),
            t({ "", "aliases: " }),
            c(1, { t("~"), { t({ "", "- " }), i(1) } }),
            t({ "", "created: " }),
            -- TODO: Weird how I can't store function node in a local variable and reuse
            f(function()
                return date():fmt("${le}")
            end),
            t({ "", "edited: " }),
            f(function()
                return date():fmt("${le}")
            end),
            t({ "", "public: false" }),
            t({ "", "tags: " }),
            c(2, { t("~"), { t({ "", "- " }), i(1) } }),
            t({ "", "---" }),
        }),
        s(
            "@today",
            f(function()
                return lf.get_date()["my-date"]
            end)
        ),
        s("@quick-content", {
            t("[["),
            i(1, "Title"),
            t(" ~ "),
            i(2, "Originators"),
            t("]]"),
        }),
        s({
            trig = "[{",
            name = "Quick Content",
            snippetType = "autosnippet",
        }, {
            t("[["),
            i(1, "Title"),
            t(" ~ "),
            i(2, "Originators"),
            t("]]"),
        }),
        s({
            trig = "[[",
            name = "Wikilink",
            snippetType = "autosnippet",
        }, {
            t("[["),
            c(1, {
                i(1, "File"),
                {
                    i(1, "File"),
                    t("|"),
                    i(2, "Alias"),
                },
                {
                    i(1, "File"),
                    t("|"),
                    i(2, "Alias"),
                    t("#"),
                    i(3, "Section"),
                },
            }),
            t("]]"),
            i(0),
        }),
    }, {
        key = "note-taking",
    })
end

local lazy_spec = {
    {
        "L3MON4D3/LuaSnip",
        event = { "BufReadPre", "BufNewFile" },
        config = config,
    },
}

return lazy_spec
