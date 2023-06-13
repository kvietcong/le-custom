-------------------------
-- Completion Setup ✅ --
-------------------------

-- nvim-cmp setup
local lspkind = require("lspkind")
local luasnip = require("le.luasnip")
local atlas = require("le.atlas")
local cmp = require("cmp")

local wikilinks_source = {}
wikilinks_source.new = function()
    local self = setmetatable({ cache = false }, { __index = wikilinks_source })
    return self
end
wikilinks_source.get_debug_name = function()
    return "wikilinks"
end
wikilinks_source.complete = function(_, _, callback)
    atlas.get_possible_paths(function(filepaths)
        local items = {}
        for _, filepath in ipairs(filepaths) do
            vim.schedule(function()
                local filename = atlas.path_to_filename(filepath)
                local insert_text = filename
                if
                    not (
                    luasnip.choice_active()
                    and luasnip.get_active_snip().name == "Wikilink"
                    )
                then
                    insert_text = "[[" .. insert_text .. "]]"
                    table.insert(items, {
                        label = filename .. "|",
                        kind = cmp.lsp.CompletionItemKind.File,
                        insertText = "[[" .. filename .. "|",
                    })
                end
                table.insert(items, {
                    label = filename,
                    kind = cmp.lsp.CompletionItemKind.File,
                    insertText = insert_text,
                })
            end)
        end
        callback(items)
    end)
end
wikilinks_source.is_available = function()
    return vim.bo.filetype == "markdown"
end
cmp.register_source("wikilinks", wikilinks_source.new())

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
        ["<Escape>"] = {
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
        { name = "emoji",                  option = { insert = true } },
        { name = "conjure" },
        { name = "path" },
        {
            name = "luasnip",
            option = {
                show_autosnippets = false,
            },
        },
        { name = "treesitter",   keyword_length = 5 },
        { name = "omni" },
        { name = "latex_symbols" },
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
                    omni = "[Omni]",
                    buffer = "[Buffer]",
                    conjure = "[Conjure]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    treesitter = "[TS]",
                    path = "[Path]",
                    emoji = "[Emoji]",
                    latex_symbols = "[LaTeX]",
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

cmp.setup.filetype("markdown", {
    sources = {
        { name = "wikilinks",    keyword_length = 2 },
        { name = "luasnip" },
        { name = "emoji",        option = { insert = true } },
        { name = "path" },
        { name = "latex_symbols" },
        { name = "nvim_lsp" },
        { name = "treesitter",   keyword_length = 4 },
        { name = "omni" },
    },
})

-- TODO: Make completion stuff my theme later (someday... maybe)
local highlights = {
    CmpItemKind = { fg = "#EED8DA", bg = "#B5585F" },
    CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE" },
    CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE" },
    CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE" },
    CmpItemMenu = { fg = "#C792EA", bg = "NONE" },
    CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
    CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
    CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },
    CmpItemKindFile = { fg = "#C3E88D", bg = "#9FBD73" },
    CmpItemKindText = { fg = "#C3E88D", bg = "#9FBD73" },
    CmpItemKindEnum = { fg = "#C3E88D", bg = "#9FBD73" },
    CmpItemKindKeyword = { fg = "#C3E88D", bg = "#9FBD73" },
    CmpItemKindConstant = { fg = "#FFE082", bg = "#D4BB6C" },
    CmpItemKindConstructor = { fg = "#FFE082", bg = "#D4BB6C" },
    CmpItemKindReference = { fg = "#FFE082", bg = "#D4BB6C" },
    CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
    CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
    CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
    CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
    CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },
    CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
    CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
    CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
    CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },
    CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
    CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
    CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },
    CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
    CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
    CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
}

for name, values in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, values)
end

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

return cmp
