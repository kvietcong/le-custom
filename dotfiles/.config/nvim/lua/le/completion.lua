-------------------------
-- Completion Setup ✅ --
-------------------------

-- nvim-cmp setup
local lspkind = require("le.lspkind")
local luasnip = require("le.luasnip")
local cmp = require("cmp")

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
        ["<C-Space>"] = cmp.mapping.complete(),
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
        -- Tab Cycling
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_prev_item()
        --     elseif luasnip.jumpable(-1) then
        --         luasnip.jump(-1)
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "emoji", option = { insert = true } },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "treesitter" },
        { name = "conjure" },
        { name = "path" },
        { name = "luasnip" },
        { name = "calc" },
        { name = "copilot" },
    }, {
        { name = "omni" },
        { name = "spell" },
        { name = "fuzzy_buffer", keyword_length = 5 },
        { name = "buffer" },
        { name = "latex_symbols" },
    }),
    formatting = {
        format = lspkind.cmp_format({
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
                fuzzy_buffer = "[FzyBuf]",
                cmdline_history = "[CMDHis]",
                copilot = "[🤖]",
                latex_symbols = "[LaTeX]",
            },
            before = function(entry, vim_item)
                pcall(function()
                    vim_item.menu = (vim_item.menu or "")
                        .. " "
                        .. entry:get_completion_item().detail
                end)
                return vim_item
            end,
        }),
    },
})

cmp.setup.filetype("markdown", {
    sources = cmp.config.sources({
        { name = "emoji", option = { insert = true } },
        { name = "luasnip" },
        { name = "calc" },
        { name = "path" },
        { name = "treesitter" },
    }, {
        { name = "omni" },
        { name = "spell" },
        { name = "fuzzy_buffer", keyword_length = 5 },
        { name = "buffer" },
        { name = "latex_symbols" },
    }),
})

-- TODO: Make completion stuff my theme later (someday... maybe)
vim.cmd([[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])

-- TODO: Decide whether to keep these or not
for _, command_type in pairs({ ":", "@" }) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "cmdline" },
            { name = "calc" },
            { name = "cmdline_history" },
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
            { name = "cmdline_history" },
        },
    })
end

return cmp
