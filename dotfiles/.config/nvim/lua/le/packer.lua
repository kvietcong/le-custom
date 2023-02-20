local plugins_path = data_path .. "/lazy"

-- Bootstrap lazy.nvim
local lazypath = plugins_path .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

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
end
vim.opt.runtimepath:prepend(hotpot_path)

-- TODO: Make things lazy load?
local lazy = require("lazy")
lazy.setup({
    "dstein64/vim-startuptime", -- Run :StartupTime

    -- Common Dependencies
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",

    -- Quality of Life
    "tpope/vim-eunuch",
    "tpope/vim-repeat",
    "godlygeek/tabular",
    "ggandor/leap.nvim",
    "folke/which-key.nvim",
    "voldikss/vim-floaterm",
    "anuvyklack/hydra.nvim",
    "echasnovski/mini.nvim",
    "sindrets/winshift.nvim",
    "mrjones2014/smart-splits.nvim",

    {
        "nanotee/zoxide.vim",
        cmd = { "Z" },
    },
    {
        "glacambre/firenvim",
        build = function()
            vim.fn["firenvim#install"](0)
        end,
    },

    -- Neovim Development
    "Olical/conjure",
    "folke/neodev.nvim",
    { "rktjmp/hotpot.nvim", lazy = false, priority = 10000 },
    "bakpakin/fennel.vim",
    "nanotee/luv-vimdocs",
    "milisims/nvim-luaref",
    "rafcamlet/nvim-luapad",
    "wlangstroth/vim-racket",
    { "eraserhd/parinfer-rust", build = "cargo build --release" },

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
    "akinsho/nvim-bufferline.lua",
    {
        "neovimhaskell/haskell-vim",
        ft = { "haskell" },
    },

    -- Writing
    -- use("jakewvincent/mkdnflow.nvim") -- For later when I move from Wikilinks
    {
        "preservim/vim-markdown",
        ft = { "markdown", "wiki" },
    },

    -- Pickers/Finders
    "tversteeg/registers.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope.nvim",
    "olacin/telescope-gitmoji.nvim",
    "kvietcong/telescope-emoji.nvim",
    "crispgm/telescope-heading.nvim",
    "nvim-telescope/telescope-packer.nvim",
    "nvim-telescope/telescope-symbols.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    "SmiteshP/nvim-gps",
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
    "hrsh7th/cmp-calc",
    "L3MON4D3/LuaSnip",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-path",
    "f3fora/cmp-spell",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-buffer",
    "ray-x/cmp-treesitter",
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "PaterJason/cmp-conjure",
    "saadparwaiz1/cmp_luasnip",
    "kdheepak/cmp-latex-symbols",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
}, {})

return lazy
