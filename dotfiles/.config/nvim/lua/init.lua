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
    "tpope/vim-repeat";
    "tpope/vim-surround";
    "nvim-lua/popup.nvim";
    "b3nj5m1n/kommentary";
    "folke/which-key.nvim";
    "nvim-lua/plenary.nvim";
    "ggandor/lightspeed.nvim";
    "lewis6991/gitsigns.nvim";
    "tversteeg/registers.nvim";
    "dstein64/vim-startuptime";
    "kyazdani42/nvim-tree.lua";
    "nvim-telescope/telescope.nvim";

    -- UI Plugins
    "luochen1990/rainbow";
    "folke/zen-mode.nvim";
    "p00f/nvim-ts-rainbow";
    "hoob3rt/lualine.nvim";
    "shaunsingh/nord.nvim";
    "andweeb/presence.nvim";
    "xiyaowong/nvim-transparent";
    "norcalli/nvim-colorizer.lua";
    "akinsho/nvim-bufferline.lua";
    "kyazdani42/nvim-web-devicons";
    "lukas-reineke/indent-blankline.nvim";

    -- LSP Plugins
    "folke/trouble.nvim";
    "hrsh7th/nvim-compe";
    "folke/lsp-colors.nvim";
    "neovim/nvim-lspconfig";
    "kosayoda/nvim-lightbulb";
    "ray-x/lsp_signature.nvim";
    "kabouzeid/nvim-lspinstall"; -- Can't use this on Windows :(
    "simrat39/symbols-outline.nvim";

    -- Treesitter Plugins
    "nvim-treesitter/nvim-treesitter";
    "nvim-treesitter/nvim-treesitter-refactor";
    "folke/twilight.nvim";
}

-- Quick Plugin Setup
require("gitsigns").setup()
require("colorizer").setup()

-- Lightspeed Setup
function repeat_ft(reverse)
  local ls = require'lightspeed'
  ls.ft['instant-repeat?'] = true
  ls.ft:to(reverse, ls.ft['prev-t-like?'])
end
vim.api.nvim_set_keymap('n', ';', '<cmd>lua repeat_ft(false)<cr>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', ';', '<cmd>lua repeat_ft(false)<cr>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ',', '<cmd>lua repeat_ft(true)<cr>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', ',', '<cmd>lua repeat_ft(true)<cr>',
                        {noremap = true, silent = true})

-- Color Scheme/Status Line
vim.g.nord_contrast = true
vim.g.nord_borders = true
require("nord").set()
require("lualine").setup { options = {
    theme = "nord",
    section_separators = {},
    component_separators = {"|"},
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

-- LSP Setup
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
require("trouble").setup()
require("compe").setup {
    enabled = true;
    autocomplete = true;
    min_length = 1;
    preselect = "enable";
    source = {
        tag = true;
        path = true;
        calc = true;
        spell = true;
        emoji = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
        treesitter = true;
    };
}
require("lsp_signature").setup()
-- LSP Install Setup for when I move back to Linux
local function setup_servers()
  require("lspinstall").setup()
  local servers = require("lspinstall").installed_servers()
  for _, server in pairs(servers) do
    require("lspconfig")[server].setup{}
  end
end
require("lspinstall").post_install_hook = function ()
  setup_servers()
  vim.cmd("bufdo e")
end
setup_servers()

-- Treesitter Setup
require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
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
                goto_definition_lsp_fallback = "gd",
                goto_next_usage = "g>",
                goto_previous_usage = "g<",
            }
        }
    }
}
require("zen-mode").setup {
    window = { width = 110, number = true },
    plugins = { options = { ruler = true }},
    gitsigns = { enable = true },
    on_open = function(win)
        vim.api.nvim_command("TransparentDisable")
    end,
    on_close = function(win)
        vim.api.nvim_command("TransparentEnable")
    end
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

-- Indenting
vim.g.indent_blankline_char = "│"
vim.cmd [[highlight Indent1 guifg=#88C0D0 guibg=NONE gui=nocombine]]
vim.cmd [[highlight Indent2 guifg=#8FBCBB guibg=NONE gui=nocombine]]
vim.cmd [[highlight Indent3 guifg=#81A1C1 guibg=NONE gui=nocombine]]
vim.g.indent_blankline_char_highlight_list = { "Indent1", "Indent2", "Indent3" }

-- Neovim tree (File explorer)
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1

-- Transparency
require("transparent").setup({ enable = true })

-- Discord Rich Presence
require("presence"):setup({
    auto_update         = true,
    neovim_image_text   = "Using an editor for people who have too much time",
    main_image          = "neovim",
    client_id           = "793271441293967371",
    log_level           = nil,
    debounce_timeout    = 10,
    enable_line_number  = false,

    editing_text        = "Editing %s",
    file_explorer_text  = "Browsing %s",
    git_commit_text     = "Committing changes",
    plugin_manager_text = "Managing plugins",
    reading_text        = "Reading %s",
    workspace_text      = "Working on %s",
    line_number_text    = "Line %s out of %s",
})

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
    c = { name  = "Commenting" },
    h = { name  = "Git Signs" }
}, { prefix     = "<Leader>" })
