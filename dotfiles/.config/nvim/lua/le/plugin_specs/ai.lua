local code_companion_config = function()
    local code_companion = require("codecompanion")
    local adapters = require("codecompanion.adapters")

    code_companion.setup({
        strategies = {
            chat = {
                adapter = "online_gemini",
            },
            inline = {
                adapter = "online_gemini",
            },
        },
        display = {
            diff = {
                provider = "mini_diff",
            },
            chat = {
                window = {
                    layout = "float",
                    border = "single",
                    height = 0.8,
                    width = 0.45,
                    relative = "editor",
                },
            },
            action_palette = {
                provider = "telescope",
            },
        },
        adapters = {
            deepseek = function()
                return adapters.extend("ollama", {
                    schema = {
                        model = {
                            default = "deepseek-r1:14b",
                        },
                    },
                })
            end,
            qwen_coder = function()
                return adapters.extend("ollama", {
                    schema = {
                        model = {
                            default = "qwen2.5-coder:14b",
                        },
                    },
                })
            end,
            online_gemini = function()
                local env_key = "GEMINI_API_KEY"
                local api_key = os.getenv(env_key)
                if require("le.lib").get_is_falsy(api_key) then
                    error(string.format("%s environment variable not set", env_key))
                end

                return adapters.extend("gemini", {
                    env = {
                        api_key = api_key,
                    },
                })
            end,
        },
    })

    local wk = require("which-key")
    wk.add({
        {
            mode = { "n", "v" },
            { "<C-a>", "<cmd>CodeCompanionActions<cr>" },
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
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = code_companion_config,
    },
}

return lazy_spec
