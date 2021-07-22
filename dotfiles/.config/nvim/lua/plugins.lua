local function setup()
    -- Bootstrapping
    local execute = vim.api.nvim_command
    local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
      execute "packadd packer.nvim"
    end

    require("packer").startup(function(use)
        use "wbthomason/packer.nvim"

        use "tpope/vim-repeat"
        use "tpope/vim-surround"
        use "folke/trouble.nvim"
        use "hrsh7th/nvim-compe"
        use "nvim-lua/popup.nvim"
        use "luochen1990/rainbow"
        use "folke/zen-mode.nvim"
        use "b3nj5m1n/kommentary"
        use "folke/twilight.nvim"
        use "p00f/nvim-ts-rainbow"
        use "hoob3rt/lualine.nvim"
        use "shaunsingh/nord.nvim"
        use "glepnir/lspsaga.nvim"
        use "folke/which-key.nvim"
        use "andweeb/presence.nvim"
        use "rafcamlet/nvim-luapad"
        use "neovim/nvim-lspconfig"
        use "folke/lsp-colors.nvim"
        use "nvim-lua/plenary.nvim"
        use "ggandor/lightspeed.nvim"
        use "lewis6991/gitsigns.nvim"
        use "tversteeg/registers.nvim"
        use "folke/todo-comments.nvim"
        use "dstein64/vim-startuptime"
        use "ray-x/lsp_signature.nvim"
        use "kyazdani42/nvim-tree.lua"
        use "neovimhaskell/haskell-vim"
        use "xiyaowong/nvim-transparent"
        use "norcalli/nvim-colorizer.lua"
        use "akinsho/nvim-bufferline.lua"
        use "kyazdani42/nvim-web-devicons"
        use "nvim-telescope/telescope.nvim"
        use "simrat39/symbols-outline.nvim"
        use "lukas-reineke/indent-blankline.nvim"
        use "nvim-treesitter/nvim-treesitter-refactor"
        use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    end)
end

local plugins = {}
plugins.setup = setup
return plugins
