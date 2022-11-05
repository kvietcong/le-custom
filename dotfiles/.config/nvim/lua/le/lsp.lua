---------------------------------------------
-- Language Server Protocol (LSP) Setup 💡 --
---------------------------------------------

-- TODO: Decompose this module

local whichkey = require("le.which-key")

local lsp_servers = {
    "rust_analyzer",
    "sumneko_lua",
    "pyright",
    "tsserver",
    "cssls",
    "html",
    "emmet_ls",
    "hls",
    "bashls",
    "cmake",
    "yamlls",
    "vimls",
    -- Make this an ARM specific ban later
    -- rather than an all "not Windows" ban
    is_win and "clangd" or nil,
}

require("nvim-lsp-installer").setup({
    ensure_installed = lsp_servers,
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
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
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.fourmolu,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.trim_newlines,

        -- Code Actions
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.code_actions.gitsigns,

        -- Diagnostics
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.flake8,
    },
})

local on_attach = function(_, bufnr)
    -- TODO: Replace vim.lsp with telescope pickers when possible
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
                s = { vim.lsp.buf.signature_help, "(c)ode (s)ignature" },
                t = { vim.lsp.buf.type_definition, "(c)ode (t)ype" },
            },
            fs = { ":Telescope lsp_document_symbols<Enter>", "(s)ymbols" },
            rn = { vim.lsp.buf.rename, "(r)e(n)ame symbol" },
        },
    }, { buffer = bufnr })
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
    sumneko_lua = {
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
    }
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
