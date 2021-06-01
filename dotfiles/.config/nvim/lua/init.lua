-- Paq Package Manager Setup
vim.cmd("packadd paq-nvim")
local paq = require("paq-nvim").paq
paq{"savq/paq-nvim", opt = true}

-- Utility Plugins
paq{"npxbr/glow.nvim"}
paq{"tpope/vim-repeat"}
paq{"tpope/vim-surround"}
paq{"nvim-lua/popup.nvim"}
paq{"b3nj5m1n/kommentary"}
paq{"folke/which-key.nvim"}
paq{"nvim-lua/plenary.nvim"}
paq{"dstein64/vim-startuptime"}
paq{"folke/todo-comments.nvim"}
paq{"kyazdani42/nvim-tree.lua"}
paq{"nvim-telescope/telescope.nvim"}
paq{"nvim-treesitter/nvim-treesitter"}

-- UI Plugins
paq{"luochen1990/rainbow"}
paq{"p00f/nvim-ts-rainbow"}
paq{"hoob3rt/lualine.nvim"}
paq{"shaunsingh/nord.nvim"} -- ATM Used for bettter Nord Lua Line
paq{"karb94/neoscroll.nvim"}
paq{"lewis6991/gitsigns.nvim"}
paq{"arcticicestudio/nord-vim"}
paq{"norcalli/nvim-colorizer.lua"}
paq{"akinsho/nvim-bufferline.lua"}
paq{"kyazdani42/nvim-web-devicons"}



-- Language Plugins
paq{"neoclide/coc.nvim"}
paq{"folke/lsp-colors.nvim"}
paq{"neovimhaskell/haskell-vim"}

-- Colorscheme Setup
vim.cmd("colorscheme nord")

-- Status Line
-- require('nord').set() -- Trouble with italics on Windows Terminal
require("lualine").setup { options = {
    theme = "nord",
    section_separators = {},
    component_separators = {"|"}
}}

-- Git Signs on the side
require("gitsigns").setup()

-- Kommentary (Commenting)
require("kommentary.config").setup()

-- Telescope (Fuzzy Finder) Setup
require('telescope').setup { defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    set_env = { ["COLORTERM"] = "truecolor" },
}}

-- Color highlighter
require("colorizer").setup()

-- Smooth Scrolling for Window Movement
require("neoscroll").setup()

-- Bufferline (File tabs)
require("bufferline").setup { options = {
    show_close_icon = false,
    seperator_style = "thin",
}}

-- TODO Comments Plugin
require("todo-comments").setup { search = {
    pattern = [[\b(KEYWORDS)\b]]
}}

-- Better Language Parsing with Tree Sitter
require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = { "Cyan1", "PaleGreen1", "Magenta1", "Gold1" },
        termcolors = { 51, 121, 201, 220 }
    }
}

--  Configuration for colorful matching brackets
--  This plugin doesn't work with Lua or Rust so I'm using two
--  Rainbow Plugins XD
vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
	guifgs = {"Cyan1", "PaleGreen1", "Magenta1", "Gold1"},
	ctermfgs = { 51, 121, 201, 220 }
}

--[[ paq{"glepnir/indent-guides.nvim"}
require('indent_guides').setup {
    even_colors = { fg ="#A3BE8C",bg= "#A3BE8C"},
    odd_colors = {fg= "#EBCB8B",bg= "#EBCB8B"}
} ]]

if vim.fn.exists("g:vscode") then
    -- Vim Wiki Setup
    paq{"vimwiki/vimwiki"}
    vim.g.vimwiki_list = {{
        path = "D:/Documents/Notes/",
        syntax = "markdown",
        ext = ".md"
    }}
    vim.g.vimwiki_create_link = 0
end

-- Neovim tree (File explorer)
vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_special_files = { "README.md", "Makefile", "MAKEFILE" }

-- Haskell Vim
vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

-- Which Key (Hotkey reminders)
local wk = require("which-key")
wk.setup()
wk.register({
    ["/"]       = "Fuzzy Find (Telescope)",
    [","]       = "First Char of Line",
    ["."]       = "Last Char of Line",
    f = {
        name    = "Telescope",
        a       = "Find Built-in Telescope Picker",
        f       = "Find Files",
        t       = "Find TODOs",
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
    c = { name = "Commenting" },
    h = { name = "Git Signs" },
}, { prefix = "<Leader>" })
