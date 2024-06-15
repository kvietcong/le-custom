local config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    mason.setup()
    return mason_lspconfig.setup({ ensure_installed = lsp_servers })
end

local lazy_spec = {
    {
        "williamboman/mason.nvim",
        config = config,
        dependencies = { "williamboman/mason-lspconfig.nvim" },
    },
}

return lazy_spec
