-- Paq Package Manager Setup
vim.cmd("packadd paq-nvim")
local paq = require("paq-nvim").paq
paq{"savq/paq-nvim", opt=true}

-- Useful to test startup time
paq{"dstein64/vim-startuptime"}

-- General UI Plugins
paq{"kyazdani42/nvim-web-devicons"}
paq{"lukas-reineke/indent-blankline.nvim", branch = "lua"}

-- General Language Plugins
paq{"neoclide/coc.nvim"}
paq{"folke/lsp-colors.nvim"}

-- General Utility Plugins
paq{"tpope/vim-repeat"}
paq{"tpope/vim-surround"}
paq{"nvim-lua/popup.nvim"}
paq{"bkad/CamelCaseMotion"}
paq{"nvim-lua/plenary.nvim"}
paq{"kyazdani42/nvim-tree.lua"}
paq{"nvim-telescope/telescope.nvim"}

-- Colorscheme Setup
paq{"arcticicestudio/nord-vim"}
vim.cmd("colorscheme nord")
-- Colorbuddy retired until startup times fixed
--[[ paq{"maaslalani/nordbuddy"}
paq{"tjdevries/colorbuddy.nvim"}
vim.g.nord_spell = "underline"
vim.g.nord_italic = false -- Disable italics because it's weird in Windows Terminal ☹
require("colorbuddy").colorscheme("nordbuddy") ]]

-- Status Line
paq{"vim-airline/vim-airline-themes"}
paq{"vim-airline/vim-airline"}
vim.g.airline_theme = "deus"

-- Git Signs on the side
paq{"lewis6991/gitsigns.nvim"}
require("gitsigns").setup()

-- Kommentary (Commenting)
paq{"b3nj5m1n/kommentary"}
require("kommentary.config").setup()

-- Color highlighter
paq{"norcalli/nvim-colorizer.lua"}
require("colorizer").setup()

-- Smooth Scrolling for Window Movement
paq{"karb94/neoscroll.nvim"}
require("neoscroll").setup()

-- Bufferline (File tabs)
paq{"akinsho/nvim-bufferline.lua"}
require("bufferline").setup()

-- Which Key (Hotkey reminders)
paq{"folke/which-key.nvim"}
require("which-key").setup()

 -- Better Language Parsing with Tree Sitter
paq{ "nvim-treesitter/nvim-treesitter"
   , run = function() vim.cmd(":TSUpdate") end }
require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    }
}

-- Vim Wiki Setup
paq{"vimwiki/vimwiki"}
vim.g.vimwiki_list = {{
    path = "D:/documents/obsidian/",
    syntax = "markdown",
    ext = ".md"
}}

--  Configuration for colorful matching brackets
paq{"luochen1990/rainbow"}
vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
	guifgs = {"Cyan1", "PaleGreen1", "Magenta1", "Gold1"},
	ctermfgs = { 51, 121, 201, 220 }
}

-- Neovim tree (File explorer)
vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_special_files = { "README.md", "Makefile", "MAKEFILE" }

-- Haskell Vim
paq{"neovimhaskell/haskell-vim"}
vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords
