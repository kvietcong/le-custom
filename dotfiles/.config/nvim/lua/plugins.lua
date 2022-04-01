local function setup()
    -- Bootstrapping
    local packer_bootstrap
    local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      packer_bootstrap = vim.fn.system({
          "git", "clone", "--depth", "1",
          "https://github.com/wbthomason/packer.nvim", install_path
      })
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
        use "nvim-telescope/telescope.nvim"
        use "nvim-treesitter/nvim-treesitter"

        -- Colorschemes
        use "shaunsingh/nord.nvim"
        use "folke/tokyonight.nvim"
        use "navarasu/onedark.nvim"
        use "sainnhe/gruvbox-material"

        -- Small UI Improvements
        use "luochen1990/rainbow"
        use "hoob3rt/lualine.nvim"
        use "p00f/nvim-ts-rainbow"
        use "folke/which-key.nvim"
        use "voldikss/vim-floaterm"
        use "akinsho/nvim-bufferline.lua"
        use "norcalli/nvim-colorizer.lua"
        use "kyazdani42/nvim-web-devicons"
        use "lukas-reineke/indent-blankline.nvim"

        use "mattn/emmet-vim"
        use "lervag/wiki.vim"
        use "hrsh7th/nvim-compe"
        use "wellle/targets.vim"
        use "folke/zen-mode.nvim"
        use "b3nj5m1n/kommentary"
        use "rafcamlet/nvim-luapad"
        use "TimUntersberger/neogit"
        use "lewis6991/gitsigns.nvim"
        use "ggandor/lightspeed.nvim"
        use "tversteeg/registers.nvim"
        use "folke/todo-comments.nvim"
        use "dstein64/vim-startuptime"
        use "ray-x/lsp_signature.nvim"
        use "kyazdani42/nvim-tree.lua"
        use "neovimhaskell/haskell-vim"
        use "simrat39/symbols-outline.nvim"
        use "nvim-treesitter/nvim-treesitter-refactor"
        use "nvim-treesitter/nvim-treesitter-textobjects"

        if packer_bootstrap then
            require("packer").sync()
        end
    end)
end

return { setup = setup }
