-------------------------
-- Completion Setup ✅ --
-------------------------

-- nvim-cmp setup
local lspkind = require("le.lspkind")
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
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.close(),
            c = cmp.mapping.close(),
        }),
        -- Enter Auto Confirm
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        -- Only use Tab for snippets
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
        { name = "calc" },
        { name = "spell",        keyword_length = 5 },
        { name = "treesitter",   keyword_length = 5 },
        { name = "omni" },
        { name = "latex_symbols" },
    },
    window = {
        completion = {
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = lspkind.cmp_format({
                mode = "symbol_text",
                menu = {
                    omni = "[Omni]",
                    buffer = "[Buffer]",
                    conjure = "[Conjure]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    treesitter = "[TS]",
                    nvim_lsp_signature_help = "[LSP]",
                    path = "[Path]",
                    emoji = "[Emoji]",
                    calc = "[Calc]",
                    spell = "[Spell]",
                    latex_symbols = "[LaTeX]",
                },
                before = function(entry_inner, vim_item_inner)
                    pcall(function()
                        vim_item_inner.menu = (vim_item_inner.menu or "")
                            .. " "
                            .. entry_inner:get_completion_item().detail
                    end)
                    return vim_item_inner
                end,
            })(entry, vim_item)

            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "    ("
                .. strings[2]
                .. ")"
                .. (kind.menu and (" " .. kind.menu) or "")
            return kind
        end,
    },
})

cmp.setup.filetype("markdown", {
    sources = {
        { name = "wikilinks",    keyword_length = 2 },
        { name = "luasnip" },
        { name = "emoji",        option = { insert = true } },
        { name = "calc" },
        { name = "path" },
        { name = "latex_symbols" },
        { name = "nvim_lsp" },
        { name = "spell",        keyword_length = 4 },
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

for _, command_type in pairs({
    -- For some reason tab completion breaks when I enable in cmd line :(
    -- It also happened after I switched to lazy.nvim. No idea why tho.
    -- TODO: Gotta figure this out
    -- ":",
    "@",
}) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "calc" },
            { name = "path" },
        },
    })
end

for _, command_type in pairs({ "/", "?" }) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "nvim_lsp_document_symbol" },
            { name = "buffer" },
            { name = "fuzzy_buffer" },
        },
    })
end

return cmp
