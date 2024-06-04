local plugins_path = data_path .. "/lazy"

-- Bootstrap lazy.nvim
local lazy_path = plugins_path .. "/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
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
if not (vim.uv or vim.loop).fs_stat(hotpot_path) then
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
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",

    -- Quality of Life
    "folke/flash.nvim",
    "tpope/vim-eunuch",
    "stevearc/oil.nvim",
    "godlygeek/tabular",
    "folke/which-key.nvim",
    "voldikss/vim-floaterm",
    "anuvyklack/hydra.nvim",
    "echasnovski/mini.nvim",
    "sindrets/winshift.nvim",
    "mrjones2014/smart-splits.nvim",
    { "eraserhd/parinfer-rust",                   build = "cargo build --release" },

    -- Neovim Development
    "Olical/conjure",
    "bakpakin/fennel.vim",

    -- Pretty Things
    "folke/zen-mode.nvim",
    "rcarriga/nvim-notify",
    "shaunsingh/nord.nvim",
    "stevearc/dressing.nvim",
    "lewis6991/gitsigns.nvim",
    "sainnhe/gruvbox-material",
    "mrjones2014/legendary.nvim",
    "norcalli/nvim-colorizer.lua",

    -- Pickers/Finders
    "nvim-telescope/telescope.nvim",
    "keyvchan/telescope-find-pickers.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    "SmiteshP/nvim-navic",
    "nvim-treesitter/nvim-treesitter",
    "hiphish/rainbow-delimiters.nvim",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "JoosepAlviste/nvim-ts-context-commentstring",

    -- LSP
    "neovim/nvim-lspconfig",
    "nvimtools/none-ls.nvim",
    "williamboman/mason.nvim",
    "ray-x/lsp_signature.nvim",
    "nvimtools/none-ls-extras.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Completion
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
}, {})

return lazy
