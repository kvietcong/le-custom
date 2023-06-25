local plugins_path = data_path .. "/lazy"

-- Bootstrap lazy.nvim
local lazy_path = plugins_path .. "/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)

-- Bootstrap hotpot.nvim
local hotpot_path = plugins_path .. "/hotpot.nvim"
if not vim.loop.fs_stat(hotpot_path) then
    vim.notify("Bootstrapping hotpot.nvim...", vim.log.levels.INFO)
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/rktjmp/hotpot.nvim.git",
        hotpot_path,
    })
    vim.cmd("helptags " .. hotpot_path .. "/doc")
end
vim.opt.runtimepath:prepend(hotpot_path)

-- TODO: Make things lazy load?
local lazy = require("lazy")
lazy.setup({
    "rktjmp/hotpot.nvim",
    "dstein64/vim-startuptime", -- Run :StartupTime

    -- Common Dependencies
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",

    -- Quality of Life
    "tpope/vim-eunuch",
    "tpope/vim-repeat",
    "stevearc/oil.nvim",
    "godlygeek/tabular",
    "folke/flash.nvim",
    "folke/which-key.nvim",
    "voldikss/vim-floaterm",
    "anuvyklack/hydra.nvim",
    "echasnovski/mini.nvim",
    "sindrets/winshift.nvim",
    "mrjones2014/smart-splits.nvim",

    -- Neovim Development
    "Olical/conjure",
    "folke/neodev.nvim",
    "bakpakin/fennel.vim",
    { "eraserhd/parinfer-rust",                   build = "cargo build --release" },

    -- Pretty Things
    "folke/zen-mode.nvim",
    "rcarriga/nvim-notify",
    "shaunsingh/nord.nvim",
    "p00f/nvim-ts-rainbow",
    "stevearc/dressing.nvim",
    "lewis6991/gitsigns.nvim",
    "sainnhe/gruvbox-material",
    "mrjones2014/legendary.nvim",
    "norcalli/nvim-colorizer.lua",

    -- Writing
    -- use("jakewvincent/mkdnflow.nvim") -- For later when I move from Wikilinks
    {
        "preservim/vim-markdown",
        ft = { "markdown", "wiki" },
    },

    -- Pickers/Finders
    "tversteeg/registers.nvim",
    "nvim-telescope/telescope.nvim",
    "kvietcong/telescope-emoji.nvim",
    "crispgm/telescope-heading.nvim",
    "keyvchan/telescope-find-pickers.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    "SmiteshP/nvim-navic",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "JoosepAlviste/nvim-ts-context-commentstring",

    -- LSP
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "ray-x/lsp_signature.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Completion
    "hrsh7th/cmp-omni",
    "L3MON4D3/LuaSnip",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "ray-x/cmp-treesitter",
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "PaterJason/cmp-conjure",
    "saadparwaiz1/cmp_luasnip",
    "kdheepak/cmp-latex-symbols",
}, {})

return lazy
