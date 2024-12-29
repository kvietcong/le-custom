local config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
        autostart = true,
        sources = {
            null_ls.builtins.formatting.gofmt,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.fnlfmt,
            null_ls.builtins.formatting.prettier,
            require("none-ls.formatting.rustfmt"),
            require("none-ls.formatting.trim_newlines"),
            require("none-ls.code_actions.eslint"),
            null_ls.builtins.code_actions.gitsigns,
            require("none-ls.diagnostics.eslint"),
            require("none-ls.diagnostics.flake8"),
        },
    })

    local wk = require("which-key")
    wk.add({ "<Leader>cf", "m'ggVG=''", desc = "format (no lsp)" })
end

local lazy_spec = {
    {
        "nvimtools/none-ls.nvim",
        config = config,
        dependencies = { "nvimtools/none-ls-extras.nvim" },
        event = { "BufReadPre", "BufNewFile" },
    },
}

return lazy_spec
