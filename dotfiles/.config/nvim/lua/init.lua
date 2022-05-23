-------------------------------------
--=================================--
--== Welcome to Le Neovim Config ==--
--=================================--
-------------------------------------

--[[ TODO: General Configuration Things
- Find out why Windows emoji selector doesn't work with Neovide
- See if I can bring most of my Obsidian Workflow into Vim
- Check out :help ins-completion
- Check out Lua Snips
- Sort out nvim-cmp sources!
- Find a way to make it not lag on LARGE files (look at init.lua for telescope-emoji)
- See what I can do with Fennel configuration
- Learn how tabs work in Vim
- Play around with Conjure (WHICH IS SUPER COOL)
]]

--------------------------
-- Setting Things Up 🔧 --
--------------------------

-- Make built-in functions easier to access
_G.vfn = vim.fn
_G.vapi = vim.api
_G.P = function(...) vim.pretty_print(...) end

-- Helpful Flags and Variables
_G.is_startup = vfn.has("vim_starting") == 1
_G.is_neovide = vim.g.neovide ~= nil
_G.is_mac = vfn.has("mac") == 1
_G.is_wsl = vfn.has("wsl") == 1
_G.is_win = vfn.has("win32") == 1
-- local is_unix = fn.has("unix") == 1
-- local is_linux = fn.has("linux") == 1
_G.is_debugging = true
_G.data_path = vfn.stdpath("data"):gsub("\\", "/")
_G.config_path = vfn.stdpath("config"):gsub("\\", "/")
_G.is_going_hard = is_neovide
_G.identity = function(...) return ... end

-- Install packer if needed
local packer_bootstrap
local packer_path = data_path .. "/site/pack/packer/start/packer.nvim"
if vfn.empty(vfn.glob(packer_path, nil, nil)) > 0 then
    packer_bootstrap = vfn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", packer_path
    })
    vapi.nvim_command("packadd packer.nvim")
end

-- Install all the plugins
local packer = require("packer")
packer.startup(function(use)
    use "wbthomason/packer.nvim"
    use "dstein64/vim-startuptime" -- Run :StartupTime
    use "lewis6991/impatient.nvim" -- Cache Lua Plugins

    -- Common Dependencies
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"
    use "kyazdani42/nvim-web-devicons"

    -- Quality of Life
    use "tpope/vim-repeat"
    use "gbprod/yanky.nvim"
    use "ggandor/leap.nvim"
    use "nacro90/numb.nvim"
    use "wellle/targets.vim"
    use "nanotee/zoxide.vim"
    use "jghauser/mkdir.nvim"
    use "folke/which-key.nvim"
    use "voldikss/vim-floaterm"
    use "echasnovski/mini.nvim"
    use "rafcamlet/nvim-luapad"
    use "TimUntersberger/neogit"
    use "kyazdani42/nvim-tree.lua"

    -- Neovim Development
    use "Olical/conjure"
    use "folke/lua-dev.nvim"
    use "rktjmp/hotpot.nvim"
    use "bakpakin/fennel.vim"
    use "nanotee/luv-vimdocs"
    use "milisims/nvim-luaref"
    use "hrsh7th/cmp-nvim-lua"

    -- Pretty Things
    use "rcarriga/nvim-notify"
    use "shaunsingh/nord.nvim"
    use "p00f/nvim-ts-rainbow"
    use "rmehri01/onenord.nvim"
    use "stevearc/dressing.nvim"
    use "beauwilliams/focus.nvim"
    use "lewis6991/gitsigns.nvim"
    -- use "arcticicestudio/nord-vim"
    use "sainnhe/gruvbox-material"
    use "neovimhaskell/haskell-vim"
    use "mrjones2014/legendary.nvim"
    use "norcalli/nvim-colorizer.lua" -- TODO: See if I can make this better?
    use "akinsho/nvim-bufferline.lua"

    -- Writing
    use "lervag/wiki.vim"
    use "godlygeek/tabular"
    use "folke/zen-mode.nvim"
    use "preservim/vim-markdown"
    use "crispgm/telescope-heading.nvim"

    -- Pickers/Finders
    use "tversteeg/registers.nvim"
    use "jvgrootveld/telescope-zoxide"
    use "nvim-telescope/telescope.nvim"
    use "olacin/telescope-gitmoji.nvim"
    use "kvietcong/telescope-emoji.nvim"
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

    -- Treesitter
    use "SmiteshP/nvim-gps"
    use "lewis6991/spellsitter.nvim"
    use "haringsrob/nvim_context_vt"
    use "romgrk/nvim-treesitter-context"
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/nvim-treesitter-refactor"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "JoosepAlviste/nvim-ts-context-commentstring"

    -- LSP
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"
    use "williamboman/nvim-lsp-installer"

    -- Completion
    use "hrsh7th/cmp-omni"
    use "hrsh7th/cmp-calc"
    use "L3MON4D3/LuaSnip"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "f3fora/cmp-spell"
    use "hrsh7th/cmp-emoji"
    use "tzachar/fuzzy.nvim"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "ray-x/cmp-treesitter"
    use "onsails/lspkind.nvim"
    use "hrsh7th/cmp-nvim-lsp"
    use "PaterJason/cmp-conjure"
    use "tzachar/cmp-fuzzy-buffer"
    use "saadparwaiz1/cmp_luasnip"
    use "dmitmel/cmp-cmdline-history"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-nvim-lsp-document-symbol"

    packer.clean()
    packer.install()

    if packer_bootstrap then
        packer.sync()
    end
end)

-- Load cached plugins for speed
require("impatient")

-- Load Fennel Integration
require("hotpot").setup({
    provide_require_fennel = true,
    compiler = {
        modules = {
            correlate = true
        },
    },
})

-- Ensure old timers are cleaned upon reloading
if not is_startup then
    vfn.timer_stopall()
end

-- Autocommand group for configuration
_G.le_group = vapi.nvim_create_augroup("LeConfiguration", { clear = true })

-- This is for sourcing on configuration change
vapi.nvim_create_autocmd({"BufWritePost"}, {
    group = le_group,
    pattern = { "init.lua", "init.vim" },
    desc = "Auto re-source configuration files.",
    -- command = "source <afile> | PackerCompile",
    command = "source $MYVIMRC | PackerCompile",
})

local plenary = require("plenary")

-- Shortcuts to Table Functions
_G.t = {
    filter = vim.tbl_filter,
    contains = vim.tbl_contains,
    map = vim.tbl_map,
    count = vim.tbl_count,
    extend = vim.tbl_extend,
    deep_extend = vim.tbl_deep_extend,
    isempty = vim.tbl_isempty,
    add_reverse_lookup = vim.tbl_add_reverse_lookup,
    get = vim.tbl_get,
    values = vim.tbl_values,
    keys = vim.tbl_keys,
    flatten = vim.tbl_flatten,
    islist = vim.tbl_islist,
    range = vfn.range,
}
_G.t = vim.tbl_extend("force", table, _G.t)

-- Load Helper Modules
plenary.reload.reload_module("lefen")
_G.lefen = require("lefen") -- My Helper module (Fennel)
plenary.reload.reload_module("lelua")
_G.lelua = require("lelua") -- My Helper module (Lua)

vapi.nvim_create_user_command("GetDate", function(command)
    local time = lefen.get_date(command.args)
    if type(time) == "string" then
        lefen.set_register_and_notify(time)
    else P(time) end
    return time
end, { nargs = "?" })

vapi.nvim_create_user_command("GetMyDate", function()
    lefen.set_register_and_notify(lefen.get_date().my_date)
end, {})

-- Which Key (Mapping reminders)
require("legendary").setup({})
local wk = require("which-key")
wk.setup()

-- Setup Evaluation w/ Fennel
local hotpot = {
    eval = require("hotpot.api.eval"),
    cache = require("hotpot.api.cache"),
}
vapi.nvim_create_autocmd({"BufEnter"}, {
    group = le_group,
    desc = "Add Fennel Keymaps",
    pattern = "*.fnl",
    callback = function(eventInfo)
        wk.register({
            name = "(e)valuate",
            b = {
                function()
                    hotpot.eval["eval-buffer"](eventInfo.buf)
                end, "(e)valuate (b)uffer"
            },
            l = {
                function()
                    hotpot.eval["eval-string"](vapi.nvim_get_current_line())
                end, "(e)valuate (l)ine"
            },
            B = {
                function()
                    P(hotpot.eval["eval-buffer"](eventInfo.buf))
                end, "(e)valuate and print (B)uffer"
            },
            L = {
                function()
                    P(hotpot.eval["eval-string"](vapi.nvim_get_current_line()))
                end, "(e)valuate and print (L)ine"
            },
        }, { prefix = "<Leader>e", buffer = eventInfo.buf })
        wk.register({
            name = "(e)valuate",
            s = { hotpot.eval["eval-selection"], "(e)valuate (s)election" },
            v = { hotpot.eval["eval-selection"], "(e)valuate (v)isual selection" },
            r = { hotpot.eval["eval-selection"], "(e)valuate (r)ange" },
        }, { prefix = "<Leader>e", buffer = eventInfo.buf, mode = "v" })
    end
})

-- Setup Evaluation w/ Lua
vapi.nvim_create_autocmd({"BufEnter"}, {
    group = le_group,
    desc = "Add Lua Keymaps",
    pattern = "*.lua",
    callback = function(eventInfo)
        wk.register({
            name = "(e)valuate",
            -- Super Ad-Hoc Evaluation. Try to find a better way.
            l = {
                function()
                    local to_eval = loadstring("P(" .. vapi.nvim_get_current_line() .. ")", nil)
                    if to_eval then
                        setfenv(to_eval, t.extend("force", cfg_env, _G))
                        to_eval()
                    else
                        lefen.notify_error("Failed to Evaluate Line")
                    end
                end, "(e)valuate (l)ine"
            },
        }, { prefix = "<Leader>e", buffer = eventInfo.buf })
    end
})

-------------------------
-- Make Neovim Pretty! --
-------------------------

-- GUI Settings
if is_neovide then
    vim.g.neovide_no_idle = false
    vim.g.neovide_refresh_rate = 165
    vim.g.neovide_transparency = 0.95
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_vfx_particle_phase = 3
    vim.g.neovide_cursor_vfx_particle_density = 30.0

    -- GUI Font resizing
    -- Thank you so much https://github.com/neovide/neovide/issues/1301#issuecomment-1119370546
    vim.g.gui_font_default_size = 14
    vim.g.gui_font_size = vim.g.gui_font_default_size
    vim.g.gui_font_face = "CodeNewRoman NF"

    local refreshGuiFont = function()
        vim.opt.guifont = string.format("%s:h%s",vim.g.gui_font_face, vim.g.gui_font_size)
    end

    local resizeGuiFont = function(delta)
        vim.g.gui_font_size = vim.g.gui_font_size + delta
        print(vim.g.gui_font_size)
        refreshGuiFont()
    end

    local resetGuiFont = function ()
        vim.g.gui_font_size = vim.g.gui_font_default_size
        refreshGuiFont()
    end

    -- Call function on startup to set default value
    resetGuiFont()

    wk.register({
        ["<Leader><Leader>"] = {
            f = {
                name = "(f)ont",
                r = {
                    name = "(r)esize",
                    k = { function() resizeGuiFont(1) end, "Bigger Font" },
                    j = { function() resizeGuiFont(-1) end, "Smaller Font" },
                    ["+"] = { function() resizeGuiFont(1) end, "Bigger Font" },
                    ["-"] = { function() resizeGuiFont(-1) end, "Smaller Font" },
                    ["="] = { function() resetGuiFont() end, "Reset Font" },
                },
            },
        },
    }, {});
end

-- Colorscheme Options
vim.g.nord_italic = true
vim.g.nord_borders = true
vim.g.nord_contrast = true
vim.g.nord_disable_background = not is_neovide
vim.g.nord_cursorline_transparent = true

require("onenord").setup ({
    theme = "dark",
    fade_nc = false,
    disable = {
        background = true,
    },
})

vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_diagnostic_virtual_text = 1
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 1

-- Select day/night colorscheme every 15 minutes
local colorschemes = { day = "gruvbox-material", night = "nord" }
local set_colorscheme = function(_--[[timer_id]])
    local colorscheme
    if lefen.get_is_day() then
        colorscheme = colorschemes.day
        vim.cmd[[set background=light]]
    else
        vim.cmd[[set background=dark]]
        colorscheme = colorschemes.night
    end

    -- Set Colorscheme
    vim.cmd("colorscheme " .. colorscheme)
end
set_colorscheme()
ColorschemeTimer = vfn.timer_start(1000 * 60 * 15,
    set_colorscheme, { ["repeat"] = -1 })

-- Make Virtual text visible with transparent backgrounds
vapi.nvim_command("highlight NonText guifg=#6C768A")

-- UI "Dressing"
require("dressing").setup()

-- Fancy Notifications
require("notify").setup({
    stages = "slide",
    timeout = 3000
})
vim.notify = require("notify")

-- Color Previews in Code
require("colorizer").setup({"*"}, {
    RGB      = false,
    RRGGBB   = true,
    names    = false,
    RRGGBBAA = false,
    rgb_fn   = false,
    hsl_fn   = false,
    css      = false,
    css_fn   = false,
    mode     = "background",
})

-- Haskell Improvements
vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

----------------------
-- Writing Setup ✍️  --
------------------- --

-- Markdown Improvements
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_strikethrough = 1
vim.g.vim_markdown_auto_insert_bullets = 0
vim.g.vim_markdown_new_list_item_indent = 0
-- Why doesn't this language aliasing work?
vim.g.vim_markdown_fenced_languages = {
    "dataviewjs=javascript",
    "dataview=sql",
}

-- Wiki Vim
vim.g.wiki_name = "- Index -"
vim.g.wiki_mappings_use_defaults = "none"
vim.g.wiki_root = "~/Documents/Notes"
vim.g.wiki_filetypes = { "md", "markdown" }
vim.g.wiki_journal = {
    name = "Journal/Weekly Reviews",
    frequency = "weekly",
    date_format = {
        daily = "%Y-%m-%d",
        weekly = "%Y-W%V",
    }
}
vim.g.wiki_index_name = "- Index -.md"
vim.g.wiki_link_toggle_on_follow = false
vapi.nvim_create_autocmd({"BufEnter"}, {
    group = le_group,
    desc = "Set note-taking keybindings for current buffer.",
    pattern = { "*.md", "*.mdx", "*.txt", "*.wiki" },
    callback = function(eventInfo)
        wk.register({
            ["<Leader>n"] = {
                name = "(n)otes",
                i = { "<Plug>(wiki-index)", "(n)ote (i)ndex" },
                b = { "<Plug>(wiki-graph-find-backlinks)", "(n)ote (b)acklinks" },
                t = { ":Telescope heading<Enter>", "(n)ote (t)able of contents" },
                w = {
                    name = "(w)eekly",
                    w = { "<Plug>(wiki-journal)", "(n)ote (w)eekly" },
                    l = { "<Plug>(wiki-journal-next)", "(n)ote (w)eekly next" },
                    h = { "<Plug>(wiki-journal-prev)", "(n)ote (w)eekly previous" },
                },
            },
            -- ["<Enter>"] = { "<Plug>(wiki-link-follow)", "Go To Wiki Link" },
            ["<Leader><Leader><Enter>"] = { "<Plug>(wiki-link-toggle)", "Create or Toggle Link" },
        }, { buffer = eventInfo.buf });
    end
})

-- Custom Note Workflow Stuff
plenary.reload.reload_module("le-atlas")
local le_atlas = require("le-atlas")
le_atlas.setup({})
vapi.nvim_create_autocmd({"BufEnter"}, {
    group = le_group,
    desc = "Set note-taking keybindings for current buffer.",
    pattern = { "*.md", "*.mdx", "*.wiki" },
    callback = function(eventInfo)
        wk.register({
            ["<Enter>"] = { le_atlas.open_wikilink_under_cursor, "Go To Wiki Link" },
            ["<Leader><Enter>"] = { function() le_atlas.open_wikilink_under_cursor(true) end, "Go To Wiki Link (Split)" },
            ["<Leader>nl"] = { le_atlas.get_link_and_copy, "Get a wikilink" },
        }, { buffer = eventInfo.buf });
        wk.register({
            ["<C-l>"] = { le_atlas.get_link_and_insert, "Get a wikilink" },
        }, { buffer = eventInfo.buf, mode = "i" });
    end,
})

vapi.nvim_create_user_command("FD", function(command)
    lefen.fd_async({command.args}, function(result) P(result) end)
end, { nargs = "?" })

-- Minimal Status Line
vim.go.laststatus = 3
require("mini.statusline").setup({
    set_vim_settings = false,
    content = {
        active = function()
            -- TODO: Add colors :D
            local os_symbols = {
                unix = "", -- e712
                dos = "", -- e70f
                mac = "", -- e711
            }
            local current_os = os_symbols.unix
            if is_win then current_os = os_symbols.dos
            elseif is_mac then current_os = os_symbols.mac
            elseif is_wsl then
                current_os = os_symbols.dos .. "+" .. os_symbols.unix
            end

            local gps = require("nvim-gps")
            local gps_string = gps.is_available() and gps.get_location() or nil

            local mode, mode_hl = MiniStatusline.section_mode({})
            mode = mode:upper()

            local git = MiniStatusline.section_git({})
            local diagnostics = MiniStatusline.section_diagnostics({})
            local filename = vfn.expand("%:~:.", nil, nil)

            local fileinfo = MiniStatusline.section_fileinfo({})

            local os = vim.bo.fileformat
            local os_symbol = os_symbols[os]
            if os_symbol then fileinfo = fileinfo:gsub(os, os_symbol) end

            local location = "%l:%v (%p%%)"

            local status_line = MiniStatusline.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git } },
                { hl = "MiniStatuslineFilename", strings = { diagnostics } },
                { hl = "MiniStatuslineDevinfo", strings = { gps_string } },
                "%=", -- End left alignment
                { hl = "MiniStatuslineDevinfo", strings = { current_os } },
                { hl = mode_hl, strings = { filename } },
                { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl, strings = { location } },
            })
            return status_line
        end
    },
})

-- Start Screen
require("mini.starter").setup({
    header =[[
__      __          _                                              _  __  __   __
\ \    / / ___     | |     __      ___    _ __     ___      o O O | |/ /  \ \ / /
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o      | ' <    \ V /
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O] |_|\_\   _\_/_
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======|_|"""""|_| """"|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-']],
})

-- Bufferline (Easy Tabs)
require("bufferline").setup { options = {
    show_close_icon = false,
    diagnostics = "nvim_lsp",
    separator_style = "thick",
    -- tab_size = 25,
    offsets = {
        {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
        },
    },
}}
wk.register({
    ["<Leader>b"] = {
        name = "(b)uffers",
        q = { ":bd<Enter>", "(b)uffer (q)lose" },
        c = { ":bd<Enter>", "(b)uffer (c)lose" },
        l = { ":BufferLineCycleNext<Enter>", "(b)uffer next" },
        h = { ":BufferLineCyclePrev<Enter>", "(b)uffer prev" },
        j = { ":BufferLineMoveNext<Enter>", "(b)uffer move next" },
        k = { ":BufferLineMovePrev<Enter>", "(b)uffer move prev" },
        o = { ":BO<Enter>", "(b)uffer (o)nly (Close all but this)" },
    },
    ["<M-l>"] = { ":BufferLineCycleNext<Enter>", "buffer next" },
    ["<M-h>"] = { ":BufferLineCyclePrev<Enter>", "buffer prev" },
    ["<M-j>"] = { ":BufferLineMoveNext<Enter>", "buffer move next" },
    ["<M-k>"] = { ":BufferLineMovePrev<Enter>", "buffer move prev" },
});

-- Neovim tree (File explorer)
require("nvim-tree").setup({
    view = {
        width = 36,
        relativenumber = true,

    },
    renderer = {
        indent_markers = {
            enable = true,
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
})
wk.register({
    ["<Leader>fe"] = { ":NvimTreeToggle<Enter>", "(f)ile (e)xplorer ((f)ind (e)xplorer)"}
});

-- Indent Indication
if is_going_hard then
    require("mini.indentscope").setup({
        draw = { delay = 500 },
        symbol = "⟫",
    })
    vapi.nvim_create_autocmd({"TermOpen"}, {
        group = le_group,
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
    })
end
vapi.nvim_command[[highlight Delimiter guifg=#4C566A]] -- Make Delimiters Less Obtrusive

-- Auto Window Resizing
require("focus").setup({
    signcolumn = false,
    cursorline = false,
    hybridnumber = true,
})

------------------------------
-- Useful Utilities Setup ⚙️ --
------------------------------

-- Line Peeking
require("numb").setup({ number_only = true })

-- Zen Mode (Minimal Mode)
require("zen-mode").setup({
    window = { width = 88, number = true },
    plugins = { options = { ruler = true }},
    gitsigns = { enable = true },
    on_open = function()
        vim.cmd[[:FocusDisable]]
        wk.register({
            ["<Escape>"] = { ":ZenMode<Enter>", "Exit Zen Mode" }
        }, { buffer = vapi.nvim_get_current_buf() })
    end,
    on_close = function()
        vim.cmd[[:FocusEnable]]
    end
})
wk.register({
    ["<Leader>z"] = { ":ZenMode<Enter>", "(z)en mode" },
});

-- Gitsigns (Sidebar Git Indicators)
require("gitsigns").setup({
    current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 100,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary> ",
})
wk.register({
    ["<Leader>"] = {
        g = {
            name = "(g)it",
            b = { ":Gitsigns blame_line<Enter>", "(g)it (b)lame line" },
            B = { ":Gitsigns toggle_current_line_blame<Enter>", "toggle (g)it (B)lame line" },
            d = { ":Gitsigns diffthis<Enter>", "(g)it (d)iff" },
            D = { ":Gitsigns toggle_deleted<Enter>", "(g)it toggle (D)eleted" },
            p = { ":Gitsigns preview_hunk<Enter>", "(g)it (p)review hunk" },
            RRR = { ":Gitsigns reset_hunk<Enter>", "(g)it (R)eset hunk (DANGER!!!)" },
        },
    },
})

-- Leap Movement
require("leap").setup({
    special_keys = {
        repeat_search = "<Enter>",
        next_match = "<Enter>",
        prev_match = "<Tab>",
        next_group = "<Space>",
        prev_group = "<Tab>",
        eol = "<Space>",
    },
})
require("leap").set_default_keymaps()

-- Git Porcelain for Neovim
require("neogit").setup({
    kind = "vsplit",
    disable_commit_confirmation = true,
    mappings = {
        status = {
            ["<Escape>"] = "Close",
        },
    },
})
wk.register({["<Leader>gg"] = { ":Neogit<Enter>", "(g)it Neo(g)it" }})

-- Floating Terminal Stuff
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
vim.g.autoclose = 2
-- Mapping in terminal mode is a bit weird in which-key right now
local clean = function (mapping)
    return vapi.nvim_replace_termcodes(mapping, true, true, true)
end
wk.register({["<C-t>"] = { ":FloatermToggle<Enter>", "Open Terminal" }});
wk.register({
    ["<C-t>"] = { clean("<C-\\><C-n>:FloatermToggle<Enter>"), "Close Terminal" },
    ["<C-n>"] = { clean("<C-\\><C-n>:FloatermNext<Enter>"), "Go To Next Terminal" },
    ["<C-p>"] = { clean("<C-\\><C-n>:FloatermPrev<Enter>"), "Go To Previous Terminal" },
    ["<C-q>"] = { clean("<C-\\><C-n>:FloatermKill<Enter>"), "Quit/Kill The Current Terminal" },
    ["<C-t><C-n>"] = { clean("<C-\\><C-n>:FloatermNew<Enter>"), "Create New Terminal" },
}, { mode = "t" });

require("yanky").setup({})
vim.keymap.set("n", "y", "<Plug>(YankyYank)", {})
vim.keymap.set("x", "y", "<Plug>(YankyYank)", {})
vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", {})
vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", {})
vim.keymap.set("x", "p", "<Plug>(YankyPutAfter)", {})
vim.keymap.set("x", "P", "<Plug>(YankyPutBefore)", {})
vim.keymap.set("n", "gp", "<Plug>(YankyGPutAfter)", {})
vim.keymap.set("n", "gP", "<Plug>(YankyGPutBefore)", {})
vim.keymap.set("x", "gp", "<Plug>(YankyGPutAfter)", {})
vim.keymap.set("x", "gP", "<Plug>(YankyGPutBefore)", {})
vapi.nvim_set_keymap("n", "<c-n>", "<Plug>(YankyCycleForward)", {})
vapi.nvim_set_keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)", {})

-- Automatically make directory upon save
require("mkdir")

-- Highlight Occurances
require("mini.cursorword").setup({ delay = 500 })

-- Trailing Space Diagnostics
require("mini.trailspace").setup({})
-- Disable Trailing Space Highlights in Certain Buffers
vapi.nvim_create_autocmd({"BufEnter"}, {
    group = le_group,
    desc = "Disable trailing space highlighting in certain buffers.",
    callback = function()
        local bufferName = vapi.nvim_eval[[bufname()]]
        local tabPageNumber = vapi.nvim_eval[[tabpagenr()]]
        if bufferName == "NvimTree_" .. tabPageNumber then
            MiniTrailspace.unhighlight()
        end
    end,
})
-- Trim Space on Save
vapi.nvim_create_autocmd({"BufWritePre"}, {
    group = le_group,
    desc = "Trim trailing spaces on save.",
    callback = function()
        MiniTrailspace.trim()
    end,
})

-- Easy Commenting
require("mini.comment").setup({})

-- Session Management
-- Close buffers that don't restore from a session
local close_bad_buffers = function()
    require("zen-mode").close()
    vim.notify.dismiss({ silent = true, pending = true })
    local buffer_numbers = vapi.nvim_list_bufs()
    for _, buffer_number in pairs(buffer_numbers) do
        -- local buffer_name = vapi.nvim_buf_get_name(buffer_number)
        local buffer_type = vapi.nvim_buf_get_option(buffer_number, "buftype")
        local is_modifiable = vapi.nvim_buf_get_option(buffer_number, "modifiable")
        if buffer_type == "nofile" or not is_modifiable then
            vapi.nvim_buf_delete(buffer_number, { force = true })
        end
    end
end
local session_path = data_path .. "/session/"
if vfn.empty(vfn.glob(session_path, nil, nil)) > 0 then
    vim.cmd("!mkdir " .. session_path)
end
require("mini.sessions").setup({
    hooks = {
        pre = {
            read = close_bad_buffers,
            write = close_bad_buffers,
        },
        post = {
            read = function()
                lefen.notify_info(
                    "Loaded Session: " .. vfn.fnamemodify(vim.v.this_session, ":t:r"))
            end,
            write = function()
                lefen.notify_info(
                    "Saved Session: " .. vfn.fnamemodify(vim.v.this_session, ":t:r"))
            end,
            delete = function()
                -- TODO: Maybe help improve
                lefen.notify_info("Deleted Selected Session")
            end,
        }
    },
    verbose = { read = false, write = false, delete = false, },
})
vapi.nvim_create_autocmd("VimLeavePre", {
    group = le_group,
    desc = "Save current session for restoration.",
    callback = function() MiniSessions.write("Last Session.vim", {}) end
})
local session_save_wrapper = function(input)
    if not input or input == "" or input == "null" then
        if vim.v.this_session and vim.v.this_session ~= "" then
            MiniSessions.write(nil, {})
            return
        end
        lefen.notify_error("Please Give Session Name")
    elseif not pcall(MiniSessions.write, input .. ".vim", {}) then
        lefen.notify_error("Session Write Has Failed (For Unknown Reasons)")
    end
end
vapi.nvim_create_user_command("SessionSave", function(command)
    session_save_wrapper(command.args)
end, { nargs = "?" })
wk.register({
    ["<Leader>ss"] = { function()
        local current_session = ""
        if vim.v.this_session and vim.v.this_session ~= "" then
            current_session = vfn.fnamemodify(vim.v.this_session, ":t:r")
        end

        local new_session_option = "[<<<Make New Session>>>]"
        local detected_names = {}
        if current_session and current_session ~= "" then
            t.insert(detected_names, 1, current_session)
        end
        for detected, _ in pairs(MiniSessions.detected) do
            local name = vfn.fnamemodify(detected, ":t:r")
            if name ~= current_session then
                t.insert(detected_names, name)
            end
        end
        t.insert(detected_names, new_session_option)

        vim.ui.select(
            detected_names,
            { prompt = "Select Session to Save To (Current: " .. current_session .. ")" },
            function(selection)
                if selection == new_session_option then
                    vim.ui.input(
                        { prompt = "Session Name to Save:" },
                        function(input)
                            session_save_wrapper(vfn.trim(input))
                        end
                    )
                elseif selection then
                    session_save_wrapper(selection)
                end
            end)
    end, "(s)ession (s)ave <Session Name>" },
    ["<Leader>sS"] = { ":SessionSave<Enter>", "(s)ession (S)ave" },
    ["<Leader>sl"] = { function()
        local current_session = nil
        if vim.v.this_session and vim.v.this_session ~= "" then
            current_session = vfn.fnamemodify(vim.v.this_session, ":t:r")
        end
        if current_session then
            vim.ui.select(
                { "Yes Save", "No Just Leave" },
                { prompt = 'Save Session "' .. current_session .. '" Before Leaving?' },
                function(_, index_selection)
                    if index_selection == 1 then
                        MiniSessions.write(nil)
                    end
                    MiniSessions.select("read")
                end
            )
        end
    end, "(s)ession (l)oad <Session Name>" },
    ["<Leader>sL"] = { function()
        MiniSessions.read(nil, {})
    end, "current (s)ession re(L)oad" },
    ["<Leader>sd"] = { function()
        MiniSessions.select("delete", { force = true })
    end, "(s)ession (d)elete" },
    ["<Leader>sn"] = { function()
        local message = "You are currently not in a session"
        local current_session = vim.v.this_session
        if current_session ~= nil then
            local session_name = vfn.fnamemodify(current_session, ":t:r")
            message = "You are currently in session `" .. session_name .. "` (" .. current_session .. ")"
        end
        print(message)
        lefen.notify_info(message)
    end, "current (s)ession (n)otify" },
    ["<Leader>sq"] = { function()
        vapi.nvim_set_vvar("this_session", "")
        lefen.notify_info("You have left the session")
    end, "(s)ession (q)uit", },
}, { silent = false })

require("mini.surround").setup({
    custom_surroundings = {
        ["|"] = { output = { left = "|", right = "|" }},
    },
    mappings = {
        add = "ys",
        delete = "ds",
        find = "gS",
        find_left = "gs",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
    },
})

-- Lua Pad (Quick Lua Testing)
require("luapad").config({
    count_limit = 5e4,
    print_highlight = "DiagnosticVirtualTextInfo",
    on_init = function()
    end,
})
wk.register({
    ["<Leader>e"] = {
        name = "(e)valuate",
        p = { ":Luapad<Enter>", "(e)valuate with lua(p)ad" },
    },
}, {})
vapi.nvim_create_user_command("Luapad", function()
    vapi.nvim_command[[botright vsplit ~/tmp/luapad.lua]]
    require("luapad.evaluator"):new({
        buf = 0,
        context = _G.cfg_env,
    }):start()
end, {})

------------------------
-- Telescope Setup 🔭 --
------------------------

local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<Esc>"] = actions.close,
            },
        },
        layout_config = {
            prompt_position = "top",
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        set_env = { ["COLORTERM"] = "truecolor" },
    },
    extensions = {
        heading = {
            treesitter = true,
        },
        gitmoji = {
            action = function(entry)
                vim.ui.input({ prompt = "Enter commit msg: " .. entry.value .. " "}, function(msg)
                    if not msg then return end
                    local commit_message = entry.value .. " " .. msg
                    lefen.set_register_and_notify(commit_message)
                end)
            end,
        },
    },
}

require("telescope-emoji").setup({
    action = function(emoji)
        require("yanky").history.push({
            regcontents = emoji.value, regtype = "v"
        })
        lefen.set_register_and_notify(emoji.value)
    end,
})

telescope.load_extension("fzf")
telescope.load_extension("emoji")
telescope.load_extension("zoxide")
telescope.load_extension("heading")
telescope.load_extension("gitmoji")
telescope.load_extension("yank_history")

-- Telescope Keymaps
wk.register({
    ["<Leader>"] = {
        f = {
            name = "(f)ind something (Telescope Pickers)",
            a = { ":Telescope<Enter>", "(f)ind (a)ll built in pickers" },
            b = { ":Telescope buffers<Enter>", "(f)ind (b)uffers" },
            c = { ":Telescope commands<Enter>", "(f)ind (c)ommands" },
            d = { ":Telescope diagnostics<Enter>", "(f)ind (d)iagnostics" },
            E = { ":Telescope emoji<Enter>", "(f)ind (E)mojis! 😎" },
            f = { ":Telescope find_files<Enter>", "(f)ind (f)iles" },
            g = { ":Telescope live_grep<Enter>", "(g)rep project" },
            h = { ":Telescope help_tags<Enter>", "(f)ind (h)elp" },
            k = { require("legendary").find, "(f)ind (k)eymaps" },
            m = { ":Telescope man_pages<Enter>", "(f)ind (m)an pages" },
            r = { ":Telescope oldfiles<Enter>", "(f)ind (r)ecent files" },
            t = { ":Telescope treesitter<Enter>", "(f)ind (t)reesitter symbols" },
            y = { ":Telescope yank_history<Enter>", "(f)ind (y)ank history" },
            z = { ":Telescope Zoxide list<Enter>", "(z)oxide" },
        },
        ["/"] = { ":Telescope current_buffer_fuzzy_find<Enter>", "Fuzzy Find In File" },
        ["?"] = { ":Telescope live_grep<Enter>", "Fuzzy Find Across Project" },
        gm = { ":Telescope gitmoji<Enter>", "(g)it (m)essage helper" },
    },
    gr = { ":Telescope lsp_references<Enter>", "Find References" },
    ["z="] = { ":Telescope spell_suggest<Enter>", "Spelling Suggestions" },
});

-------------------------
-- Treesitter Setup 🌳 --
-------------------------

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        disable = { "markdown" },
        additional_vim_regex_highlighting = { "markdown" },
    },
    context_commentstring = { enable = true },
    ensure_installed = {
        "c", "lua", "rust", "bash", "clojure", "cmake",
        "css", "commonlisp", "erlang", "fennel", "go",
        "glsl", "haskell", "java", "html", "http",
        "javascript", "json", "latex", "make", "markdown",
        "ocaml", "python", "regex", "scheme", "svelte",
        "swift", "toml", "vim", "yaml", "wgsl", "tsx",
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = { -- TODO: Look more at these
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    refactor = {
        -- highlight_current_scope = { enable = true },
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Leader>rn",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition_lsp_fallback = "gd",
                goto_next_usage = "g>",
                goto_previous_usage = "g<",
            }
        },
    },
    textobjects = {
        lsp_interop = { enable = true },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ap"] = "@parameter.outer",
                ["ip"] = "@parameter.inner",
                ["ak"] = "@comment.outer"
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<Leader>csn"] = "@parameter.inner",
            },
            swap_previous = {
                ["<Leader>csp"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]c"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]C"] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[c"] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[C"] = "@class.outer",
            },
        },
    },
})

require("spellsitter").setup()

if is_going_hard then
    require("nvim-gps").setup({
        separator = " ▶ ",
    })
end

require("treesitter-context").setup({
    enable = is_going_hard,
    patterns = {
        default = {
            "class", "function", "method",
            "for", "while", "if", "switch", "case",
        },
    },
})

require("nvim_context_vt").setup({
    enabled = is_going_hard,
    min_rows = 5,
    custom_parser = function(node, _, _)
        local start_row, _, end_row = node:range()
        local lines = vapi.nvim_buf_get_lines(vapi.nvim_get_current_buf(), start_row, end_row, false)
        if node:type() == "function" then return nil end

        return "~> " .. lines[1]:match("^%s*(.-)%s*$") .. "…"
    end,
})

---------------------------------------------
-- Language Server Protocol (LSP) Setup 💡 --
---------------------------------------------

local lsp_servers = {
    "rust_analyzer", "sumneko_lua", "clangd", "pyright",
    "tsserver", "cssls", "html", "emmet_ls",
    "hls", "bashls", "cmake", "yamlls", "vimls",
}

require("nvim-lsp-installer").setup({
    ensure_installed = lsp_servers,
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

local on_attach = function(_, bufnr)
    vapi.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})

    wk.register({
        g = {
            name = "(g)o to",
            d = { vim.lsp.buf.definition, "(g)o to (d)efinition" },
            D = { vim.lsp.buf.declaration, "(g)o to (D)eclaration" },
            i = { vim.lsp.buf.implementation, "(g)o to (i)mplementation" },
            -- r = { vim.lsp.buf.references, "(g)o to (r)eferences" },
        },
        ["<Leader>"] = {
            c = {
                name = "(c)ode",
                a = { vim.lsp.buf.code_action, "(c)ode (a)ction" },
                f = { vim.lsp.buf.formatting, "(c)ode (f)ormatting" },
                h = { vim.lsp.buf.hover, "(c)ode (h)over" },
                s = { vim.lsp.buf.signature_help, "(c)ode (s)ignature" },
                t = { vim.lsp.buf.type_definition, "(c)ode (t)ype" },
            },
            fs = { ":Telescope lsp_document_symbols<Enter>", "(s)ymbols" },
            rn = { vim.lsp.buf.rename, "(r)e(n)ame symbol" },
        },
    }, { buffer = bufnr });
end
vapi.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function() vim.opt_local.wrap = true end,
    -- TODO: Open issue on why wrap only works after you go to the file
    -- then come back
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local runtime_path = vim.split(package.path, ';')
t.insert(runtime_path, "lua/?.lua")
t.insert(runtime_path, "lua/?/init.lua")

local lspconfig = require("lspconfig")
local luadev = require("lua-dev").setup({
    library = {
        plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    runtime_path = true,
    lspconfig = {
        settings = {
            Lua = {
                diagnostics = { globals = {
                    -- Neovim Stuff
                    "vim", "P", "MiniSessions",
                    "MiniStatusline", "MiniTrailspace",

                    -- AwesomeWM Stuff
                    "awesome", "screen", "client",
                    "root", "tag", "widget",
                }},
            },
        },
    },
})
local lsp_settings = {
    -- My Old Lua LSP settings (Might be useful for non vim projects?)
    -- sumneko_lua = {
    --     settings = {
    --         Lua = {
    --             runtime = { version = "LuaJIT", path = runtime_path },
    --             diagnostics = { globals = { "vim" } },
    --             -- Make the server aware of Neovim runtime files
    --             workspace = { library = vapi.nvim_get_runtime_file("", true) },
    --         },
    --     },
    -- }
    sumneko_lua = luadev
}

if is_startup then -- Only load LSPs on startup
    for _, server in ipairs(lsp_servers) do
        local setup = {}
        if lsp_settings[server] ~= nil then
            setup = lsp_settings[server]
        end
        setup.on_attach = on_attach
        setup.capabilities = capabilities
        lspconfig[server].setup(setup)
    end
end

require("lsp_signature").setup({
    hint_enable = true,
    hint_prefix = "✅ "
})

-------------------------
-- Completion Setup ✅ --
-------------------------

local luasnip = require("luasnip")

-- nvim-cmp setup
local lspkind = require("lspkind")
local cmp = require("cmp")
cmp.setup({
    experimental = {
        ghost_text = true,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.close(), c = cmp.mapping.close()
        }),
        -- Enter Auto Confirm
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        -- Only use Tab for snippets
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        -- Tab Cycling
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_prev_item()
        --     elseif luasnip.jumpable(-1) then
        --         luasnip.jump(-1)
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
    }),
    sources = cmp.config.sources(
        {
            { name = "emoji", option = { insert = true } },
            { name = "omni" },
            { name = "conjure" },
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua" },
            { name = "path" },
            { name = "luasnip" },
            { name = "calc" },
            { name = "treesitter" },
        },
        {
            { name = "spell" },
            { name = "fuzzy_buffer", keyword_length = 5 },
            { name = "buffer" },
        }
    ),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                omni = "[Omni]",
                buffer = "[Buffer]",
                conjure = "[Conjure]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                treesitter = "[TreeSitter]",
                nvim_lsp_signature_help = "[LSP Sig]",
                path = "[Path]",
                emoji = "[Emoji]",
                calc = "[Calc]",
                spell = "[Spell]",
                fuzzy_buffer = "[Fzy Buffer]",
                cmdline_history = "[CMD History]",
            }),
        })
    },
})

-- TODO: Make completion stuff my theme later (someday... maybe)
vim.cmd[[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]]

for _, command_type in pairs({":", "@"}) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "cmdline" },
            { name = "calc" },
            { name = "cmdline_history" },
            { name = "path" },
        },
    })
end
for _, command_type in pairs({"/", "?"}) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "nvim_lsp_document_symbol" },
            { name = "buffer" },
            { name = "fuzzy_buffer" },
            { name = "cmdline_history" },
        },
    })
end

-------------------
-- Miscellaneous --
-------------------

-- Misc Mappings
wk.register({
    s = {
        name    = "(s)essions",
    },
    ["<Leader>s"] = {
        name = "(s)pelling",
        a = "Add to Dictionary",
        r = "Remove from Dictionary",
        u = "Undo Last Dictionary Action",
        l = "Go to Next Spelling Error",
        h = "Go to Previous Spelling Error",
    },
    w = { name = "(w)indow (Ctrl-w)" },
    c = {
        ["-"] = "Comment Banner (--)",
        ["="] = "Comment Banner (==)",
        ["/"] = "Comment Banner (//)",
    },
    ["<Leader>"] = {
        q = { ":qa<Enter>", "(q)uit all" },
        r = { function()
            vim.cmd[[source $MYVIMRC]]
            lefen.notify_info("Configuration Reloaded")
        end, "(r)e-source config" },
    },
}, { prefix     = "<Leader>" })

-- For REPL or Debug Purposes
_G.cfg_env = lefen.get_locals()
