--[[
TODO: Checkout Neorg when I think seems stable/mature
      enough to move my notes (i.e. when there's a pandoc
      option to convert markdown to neorg)
]]

vim.cmd [[packadd packer.nvim]]
require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    -- Utility Plugins
    use "tpope/vim-repeat"
    use "tpope/vim-surround"
    use "nvim-lua/popup.nvim"
    use "b3nj5m1n/kommentary"
    use "folke/which-key.nvim"
    use "nvim-lua/plenary.nvim"
    use "ggandor/lightspeed.nvim"
    use "lewis6991/gitsigns.nvim"
    use "tversteeg/registers.nvim"
    use "dstein64/vim-startuptime"
    use "kyazdani42/nvim-tree.lua"
    use "nvim-telescope/telescope.nvim"

    -- UI Plugins
    use "luochen1990/rainbow"
    use "folke/zen-mode.nvim"
    use "p00f/nvim-ts-rainbow"
    use "hoob3rt/lualine.nvim"
    use "shaunsingh/nord.nvim"
    use "andweeb/presence.nvim"
    use "xiyaowong/nvim-transparent"
    use "norcalli/nvim-colorizer.lua"
    use "akinsho/nvim-bufferline.lua"
    use "kyazdani42/nvim-web-devicons"
    use "lukas-reineke/indent-blankline.nvim"

    -- LSP Plugins
    use "folke/trouble.nvim"
    use "hrsh7th/nvim-compe"
    use "glepnir/lspsaga.nvim"
    use "folke/lsp-colors.nvim"
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"
    use "simrat39/symbols-outline.nvim"

    -- Treesitter Plugins
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/nvim-treesitter-refactor"
    use "folke/twilight.nvim"
end)

-- Quick Plugin Setup
require("gitsigns").setup()
require("colorizer").setup()

-- Lightspeed Setup
function Repeat_Search(reverse)
  local ls = require'lightspeed'
  ls.ft["instant-repeat?"] = true
  ls.ft:to(reverse, ls.ft["prev-t-like?"])
end
vim.api.nvim_set_keymap("n", ";", ":lua Repeat_Search(false)<cr>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", ";", ":lua Repeat_Search(false)<cr>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", ",", ":lua Repeat_Search(true)<cr>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap("x", ",", ":lua Repeat_Search(true)<cr>",
                        {noremap = true, silent = true})

-- Color Scheme/Status Line
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
require("lsp_signature").setup({
    hint_enable = true,
    hint_prefix = "✅ "
})
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap("n", "<Leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
end
local servers = { "pyright", "hls", "clangd", "html", "cssls", "tsserver" }
for _, server in pairs(servers) do
    require("lspconfig")[server].setup{ on_attach = on_attach }
end
-- Only have Lua configured for Windows atm
if vim.fn.has("win32") == 1 then
    local sumneko_root = "D:/Custom Binaries/lua-language-server-2.3/"
    local sumneko_binary = sumneko_root .. "/bin/lua-language-server"
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    require("lspconfig").sumneko_lua.setup {
        cmd = { sumneko_binary, "-E", sumneko_root .. "main.lua" };
        settings = { Lua = {
            runtime = { version = "LuaJIT", path = runtime_path },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = true }
        }},
        on_attach = on_attach
    }
end

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
                goto_definition_lsp_fallback = "gnd",
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
    on_open = function()
        vim.api.nvim_command("TransparentDisable")
    end,
    on_close = function()
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
-- Colored indents
-- vim.cmd [[highlight Indent1 guifg=#88C0D0 guibg=NONE gui=nocombine]]
-- vim.cmd [[highlight Indent2 guifg=#8FBCBB guibg=NONE gui=nocombine]]
-- vim.cmd [[highlight Indent3 guifg=#81A1C1 guibg=NONE gui=nocombine]]
-- vim.g.indent_blankline_char_highlight_list = { "Indent1", "Indent2", "Indent3" }

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
