local function setup()
    -- Bootstrapping
    local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
      vim.api.nvim_command "packadd packer.nvim"
    end

    require("packer").startup(function(use)
        use "wbthomason/packer.nvim"

        -- Essentials
        use "tpope/vim-repeat"
        use "tpope/vim-surround"
        use "nvim-lua/popup.nvim"
        use "nvim-lua/plenary.nvim"
        use "neovim/nvim-lspconfig"
        use "nvim-treesitter/nvim-treesitter"
        use "nvim-telescope/telescope.nvim"

        -- Colorschemes
        use "shaunsingh/nord.nvim"
        use "folke/tokyonight.nvim"
        use "sainnhe/gruvbox-material"
        use "marko-cerovac/material.nvim"

        -- Small UI Improvements
        use "luochen1990/rainbow"
        use "folke/twilight.nvim"
        use "hoob3rt/lualine.nvim"
        use "p00f/nvim-ts-rainbow"
        use "folke/which-key.nvim"
        use "folke/lsp-colors.nvim"
        use "voldikss/vim-floaterm"
        use "akinsho/nvim-bufferline.lua"
        use "norcalli/nvim-colorizer.lua"
        use "kyazdani42/nvim-web-devicons"
        use "lukas-reineke/indent-blankline.nvim"

        use "lervag/wiki.vim"
        use "folke/trouble.nvim"
        use "hrsh7th/nvim-compe"
        use "folke/zen-mode.nvim"
        use "b3nj5m1n/kommentary"
        use "rafcamlet/nvim-luapad"
        use "ggandor/lightspeed.nvim"
        use "lewis6991/gitsigns.nvim"
        use "tversteeg/registers.nvim"
        use "folke/todo-comments.nvim"
        use "dstein64/vim-startuptime"
        use "ray-x/lsp_signature.nvim"
        use "kyazdani42/nvim-tree.lua"
        use "neovimhaskell/haskell-vim"
        use "iamcco/markdown-preview.nvim"
        use "simrat39/symbols-outline.nvim"
        use "nvim-treesitter/nvim-treesitter-refactor"
        use "nvim-treesitter/nvim-treesitter-textobjects"
    end)
end

return { setup = setup }
