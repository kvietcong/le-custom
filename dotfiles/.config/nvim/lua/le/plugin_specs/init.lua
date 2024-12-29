local lazy_spec = {
    "nvim-lua/plenary.nvim",
    { "kyazdani42/nvim-web-devicons", config = true },
    { "dstein64/vim-startuptime", cmd = { "StartupTime" } },

    -- Quality of Life
    "tpope/vim-eunuch",
    {
        "Exafunction/codeium.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({})
        end,
    },
    {
        "Goose97/timber.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Pretty Things
    { "stevearc/dressing.nvim", config = true },
    {
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd("colorscheme tokyonight")
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
                filter = vim.log.levels.TRACE,
                window = {
                    x_padding = 0,
                    max_width = 120,
                    winblend = 20,
                    normal_hl = "Cursorline",
                    border = "solid",
                    border_hl = "Cursorline",
                },
            },
        },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "classic",
                hi = { background = "None" },
            })
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
}

return lazy_spec
