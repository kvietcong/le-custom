local config = function()
    local code_companion = require("codecompanion")
    code_companion.setup({
        strategies = {
            chat = {
                adapter = "deepseek",
                -- adapter = "qwen_coder",
            },
        },
        adapters = {
            deepseek = function()
                return require("codecompanion.adapters").extend("ollama", {
                    schema = {
                        model = {
                            default = "deepseek-r1:14b",
                        },
                    },
                })
            end,
            qwen_coder = function()
                return require("codecompanion.adapters").extend("ollama", {
                    schema = {
                        model = {
                            default = "qwen2.5-coder:14b",
                        },
                    },
                })
            end,
        },
    })

    local wk = require("which-key")
    wk.add({
        {
            mode = { "n", "v" },
            { "<C-a>",          "<cmd>CodeCompanionActions<cr>" },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>" },
        },
        {
            mode = { "v" },
            { "ga", ":CodeCompanionChat Add<Enter>" },
        },
    })

    vim.cmd([[cab cc CodeCompanion]])
end

local lazy_spec = {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = config,
}

return lazy_spec
