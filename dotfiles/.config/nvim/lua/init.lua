--[[
TODO: Possibly move to Packer
TODO: Checkout Neorg when I think seems stable/mature
      enough to move my notes (i.e. when there's a pandoc
      option to convert markdown to neorg)
]]

-- Paq Package Manager Setup
local paq = require("paq") {
    "savq/paq-nvim"; -- Let Paq manage itself

    -- Utility Plugins
    "npxbr/glow.nvim";
    "tpope/vim-repeat";
    "tpope/vim-surround";
    "nvim-lua/popup.nvim";
    "b3nj5m1n/kommentary";
    "folke/which-key.nvim";
    "nvim-lua/plenary.nvim";
    "lewis6991/gitsigns.nvim";
    "dstein64/vim-startuptime";
    "kyazdani42/nvim-tree.lua";
    "nvim-telescope/telescope.nvim";

    -- Treesitter Stuff
    "nvim-treesitter/nvim-treesitter";
    "nvim-treesitter/nvim-treesitter-refactor";
    "windwp/nvim-ts-autotag";
    "folke/twilight.nvim";

    -- UI Plugins
    "luochen1990/rainbow";
    "folke/zen-mode.nvim";
    "p00f/nvim-ts-rainbow";
    "hoob3rt/lualine.nvim";
    "shaunsingh/nord.nvim";
    "arcticicestudio/nord-vim";
    "norcalli/nvim-colorizer.lua";
    "akinsho/nvim-bufferline.lua";
    "kyazdani42/nvim-web-devicons";

    -- Language Plugins
    "neoclide/coc.nvim";
    "folke/lsp-colors.nvim";
}

-- Quick Plugin Setup
require("gitsigns").setup()
require("colorizer").setup()

-- Status Line
require("nord").set()
require("lualine").setup { options = {
    theme = "nord",
    section_separators = {},
    component_separators = {"|"}
}}

-- Telescope (Fuzzy Finder) Setup
require('telescope').setup { defaults = {
    layout_config = {
        prompt_position = "top",
    },
    layout_strategy = "flex",
    sorting_strategy = "ascending",
    set_env = { ["COLORTERM"] = "truecolor" },
}}

-- Bufferline (File tabs)
require("bufferline").setup { options = {
    show_close_icon = false,
    seperator_style = "thin",
}}

-- Treesitter Setup
require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    autotag = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = { "Cyan1", "PaleGreen1", "Magenta1", "Gold1" },
        termcolors = { 51, 121, 201, 220 }
    },
    refactor = {
        highlight_definitions = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gd",
                goto_next_usage = "gnu",
                goto_previous_usage = "gpu",
            }
        }
    }
}
require("zen-mode").setup {
    window = { width = 110, number = true },
    plugins = { options = { ruler = true }},
    gitsigns = { enable = true }
}
require("twilight").setup()

--  Configuration for colorful matching brackets
--  This plugin doesn't work with Lua or Rust so I'm using two
--  Rainbow Plugins XD
vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
	guifgs = {"Cyan1", "PaleGreen1", "Magenta1", "Gold1"},
	ctermfgs = { 51, 121, 201, 220 }
}

-- Neovim tree (File explorer)
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1

-- Which Key (Hotkey reminders)
local wk = require("which-key")
wk.setup()
wk.register({
    ["/"]       = "Fuzzy Find",
    [","]       = "Go to first Non-Space Character",
    ["."]       = "Go to end of line",
    f = {
        name    = "Telescope",
        a       = "Find Built-in Telescope Picker",
        f       = "Find Files",
        b       = "Find Buffers",
        g       = "Find w/ grep",
        h       = "Find Help (From Vim)",
        m       = "Find Man Page",
        e       = "File Explorer"
    },
    s = {
        name    = "Spelling",
        a       = "Add to Dictionary",
        r       = "Remove from Dictionary",
        u       = "Undo Last Dictionary Action"
    },
    b = {
        name    = "Buffers",
        n       = "Next Buffer",
        p       = "Previous Buffer",
        mn      = "Move Buffer to Next",
        mp      = "Move Buffer to Previous"
    },
    g = {
        name    = "COC",
    },
    c = { name  = "Commenting" },
    h = { name  = "Git Signs" }
}, { prefix     = "<Leader>" })
