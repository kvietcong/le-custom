local config = function()
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")
    local cmp = require("cmp")

    cmp.setup({
        preselect = cmp.PreselectMode.None,
        experimental = {
            ghost_text = true,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-k>"] = cmp.mapping.scroll_docs(-4),
            ["<C-j>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(nil),
            ["<Down>"] = {
                i = function()
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp.complete()
                    end
                end,
            },
            ["<C-c>"] = {
                i = function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                        vapi.nvim_feedkeys(require("le.libf").clean("<Esc>"), "n", false)
                    else
                        fallback()
                    end
                end,
            },
            ["<Up>"] = {
                i = function()
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp.complete()
                    end
                end,
            },
            ["<Enter>"] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        })
                    else
                        fallback()
                    end
                end,
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = {
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "emoji", option = { insert = true } },
            { name = "conjure" },
            { name = "path" },
            {
                name = "luasnip",
                option = {
                    show_autosnippets = false,
                },
            },
            { name = "treesitter", keyword_length = 5 },
        },
        window = {
            completion = {
                side_padding = 0,
                col_offset = -3,
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            },
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local new_entry = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    menu = {
                        buffer = "[Buffer]",
                        conjure = "[Conjure]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        treesitter = "[TS]",
                        path = "[Path]",
                        emoji = "[Emoji]",
                    },
                    before = function(entry_inner, vim_item_inner)
                        pcall(function()
                            vim_item_inner.menu = (vim_item_inner.menu or "")
                                .. " "
                                .. (entry_inner:get_completion_item().detail or "")
                        end)
                        return vim_item_inner
                    end,
                })(entry, vim_item)

                local strings = vim.split(new_entry.kind, "%s", { trimempty = true })
                new_entry.kind = " " .. (strings[1] or "") .. " "
                new_entry.menu = "    ("
                    .. (strings[2] or "")
                    .. ")"
                    .. (new_entry.menu and (" " .. new_entry.menu) or "")
                return new_entry
            end,
        },
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "path" },
            { name = "cmdline" },
        },
    })

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
            { name = "fuzzy_buffer" },
        },
    })
end

local lazy_spec = {
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
        config = config,
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                opts = {
                    region_check_events = {
                        "CursorMoved",
                        "CursorHold",
                        "InsertEnteer",
                    },
                },
            },
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "ray-x/cmp-treesitter",
            "onsails/lspkind.nvim",
            "PaterJason/cmp-conjure",
            "saadparwaiz1/cmp_luasnip",
        },
    },
}

return lazy_spec
