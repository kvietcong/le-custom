---------------------------------------------
-- Language Server Protocol (LSP) Setup 💡 --
---------------------------------------------

local config = function()
    local wk = require("which-key")

    local on_attach = function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
            local navic = require("nvim-navic")
            navic.attach(client, buffer)
        end
        wk.add({
            { "gd", ":Telescope lsp_definitions<Enter>", desc = "see definitions" },
            { "gD", vim.lsp.buf.declaration, desc = "see declaration" },
            {
                "gi",
                ":Telescope lsp_implementations<Enter>",
                desc = "see implementations",
            },
            { "gr", ":Telescope lsp_references<Enter>", desc = "see references" },
        })
        wk.add({
            { "<Leader>c", group = "code" },
            { "<Leader>ca", vim.lsp.buf.code_action, desc = "actions" },
            { "<Leader>cd", vim.diagnostic.open_float, desc = "diagnostics" },
            { "<Leader>cf", vim.lsp.buf.format, desc = "format (lsp)" },
            { "<Leader>ch", vim.lsp.buf.hover, desc = "hover" },
            { "<Leader>cs", vim.lsp.buf.signature_help, desc = "signature" },
            { "<Leader>ct", vim.lsp.buf.type_definition, desc = "type" },
        })
        wk.add({
            { "<Leader>fs", ":Telescope lsp_document_symbols<Enter>", desc = "symbols" },
            { "<Leader>rn", vim.lsp.buf.rename, desc = "rename" },
            { "<F2>", vim.lsp.buf.rename, desc = "rename" },
        })
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local runtime_path = vim.split(package.path, ";", nil)
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

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
                            "PR",
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
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
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

    local lspconfig = require("lspconfig")
    for _, server in ipairs(LSP_SERVERS) do
        local setup = {}
        if lsp_settings[server] ~= nil then
            setup = lsp_settings[server]
        end
        setup.on_attach = on_attach
        setup.capabilities = capabilities
        lspconfig[server].setup(setup)
    end
end

local lazy_spec = {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = config,
        dependencies = {
            "SmiteshP/nvim-navic",
            {
                "ray-x/lsp_signature.nvim",
                opts = {
                    hint_enable = true,
                    transparency = 10,
                },
            },
        },
    },
}

return lazy_spec
