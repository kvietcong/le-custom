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
            ["<Up>"] = {
                i = function()
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp.complete()
                    end
                end,
            },
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
                        vim.api.nvim_feedkeys(
                            require("le.lib").clean("<Esc>"),
                            "n",
                            false
                        )
                    else
                        fallback()
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
            { name = "nvim_lsp" },
            { name = "emoji", option = { insert = true } },
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
            format = lspkind.cmp_format({
                mode = "symbol",
                menu = {
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    treesitter = "[TS]",
                    path = "[Path]",
                    emoji = "[Emoji]",
                },
            }),
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
        commit = "b356f2c", -- See https://github.com/hrsh7th/nvim-cmp/issues/1877 for more info on the snippet bug
        pin = true,
        event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
        config = config,
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                opts = {
                    region_check_events = {
                        "CursorMoved",
                        "CursorHold",
                        "InsertEnter",
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
            "saadparwaiz1/cmp_luasnip",
        },
    },
}

return lazy_spec
