local lazy_spec = {
    { "rktjmp/hotpot.nvim",       lazy = false,           priority = 9999 },

    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    { "dstein64/vim-startuptime", cmd = { "StartupTime" } },

    -- Quality of Life
    "tpope/vim-eunuch",
    "godlygeek/tabular",
    "echasnovski/mini.nvim",

    -- Neovim Development
    "bakpakin/fennel.vim",

    -- Pretty Things
    "rcarriga/nvim-notify",
    "stevearc/dressing.nvim",
    "norcalli/nvim-colorizer.lua",
}

return lazy_spec
