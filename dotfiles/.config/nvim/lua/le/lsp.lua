---------------------------------------------
-- Language Server Protocol (LSP) Setup 💡 --
---------------------------------------------

-- TODO: Decompose this module

local whichkey = require("le.which-key")

local lsp_servers = {
    "rust_analyzer",
    "lua_ls",
    "pyright",
    "tsserver",
    "cssls",
    "html",
    "emmet_ls",
    "hls",
    "bashls",
    "yamlls",
    "wgsl_analyzer",
    "vimls",
}

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = lsp_servers,
})

-- Null-ls Hook Setup
local null_ls = require("null-ls")
null_ls.setup({
    autostart = true,
    sources = {
        -- Formatting
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.fnlfmt,
        -- null_ls.builtins.formatting.eslint,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.fourmolu,
        null_ls.builtins.formatting.trim_newlines,

        -- Code Actions
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.code_actions.gitsigns,

        -- Diagnostics
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.flake8,
    },
})

-- Format Command
vapi.nvim_create_user_command("Format", function()
    vim.lsp.buf.format({ async = true })
end, {})

local on_attach = function(client, buffer)
    local navic = require("nvim-navic")
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, buffer)
    end
    whichkey.register({
        g = {
            name = "(g)o to",
            d = { ":Telescope lsp_definitions<Enter>", "(g)o to (d)efinition" },
            D = { vim.lsp.buf.declaration, "(g)o to (D)eclaration" },
            i = { ":Telescope lsp_implementations<Enter>", "(g)o to (i)mplementation" },
            r = { ":Telescope lsp_references<Enter>", "(g)o to (r)eferences" },
        },
        ["<Leader>"] = {
            c = {
                name = "(c)ode",
                a = { vim.lsp.buf.code_action, "(c)ode (a)ction" },
                d = { vim.diagnostic.open_float, "(c)ode (d)iagnostic" },
                f = { ":Format<Enter>", "(c)ode (f)ormatting" },
                h = { vim.lsp.buf.hover, "(c)ode (h)over" },
                s = { vim.lsp.buf.signature_help, "(c)ode (s)ignature" },
                t = { vim.lsp.buf.type_definition, "(c)ode (t)ype" },
            },
            fs = { ":Telescope lsp_document_symbols<Enter>", "(s)ymbols" },
            rn = { vim.lsp.buf.rename, "(r)e(n)ame symbol" },
        },
    }, { buffer = buffer })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local runtime_path = vim.split(package.path, ";", nil)
t.insert(runtime_path, "lua/?.lua")
t.insert(runtime_path, "lua/?/init.lua")

local lspconfig = require("lspconfig")
local luadev = require("neodev").setup({
    library = {
        plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
})

local lsp_settings = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = runtime_path },
                diagnostics = {
                    globals = {
                        -- Neovim Stuff
                        "vim",
                        "P",
                        "MiniSessions",
                        "MiniStatusline",
                        "MiniTrailspace",
                        "MiniBufremove",

                        -- AwesomeWM Stuff
                        "awesome",
                        "screen",
                        "client",
                        "root",
                        "tag",
                        "widget",
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = { library = vapi.nvim_get_runtime_file("", true) },
            },
        },
    },
    yamlls = {
        settings = {
            yaml = {
                keyOrdering = false,
            },
        },
    },
}

if is_startup then -- Only load LSPs on startup
    for _, server in ipairs(lsp_servers) do
        local setup = {}
        if lsp_settings[server] ~= nil then
            setup = lsp_settings[server]
        end
        setup.on_attach = on_attach
        setup.capabilities = capabilities
        lspconfig[server].setup(setup)
    end
end

require("lsp_signature").setup({
    hint_enable = true,
    hint_prefix = "✅ ",
})

return { null_ls = null_ls, lspconfig = lspconfig, luadev = luadev }
