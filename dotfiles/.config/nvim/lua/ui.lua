local helpers = require("helpers")
local is_day = helpers.is_day
local map = helpers.map

--- Setup colorscheme stuff
local function setup_colors()
    vim.g.nord_borders = true
    vim.g.material_style = "oceanic"
    vim.g.material_disable_background = false
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_diagnostic_virtual_text = 1
    vim.g.gruvbox_material_diagnostic_text_highlight = 1
    vim.g.gruvbox_material_diagnostic_line_highlight = 1

    local lualine_colors = {
        nord = "nord",
        tokyonight = "tokyonight",
        ["gruvbox-material"] = "gruvbox_material",
        material = "material-nvim"
    }
    local colorschemes = { day = "gruvbox-material", night = "nord" }
    local colorscheme

    if is_day() then
        colorscheme = colorschemes.day
        vim.g.tokyonight_style = "day"
        vim.g.material_style = "lighter"
        vim.cmd[[set background=light]]
        lualine_colors["gruvbox-material"] = "gruvbox_light"
    else
        colorscheme = colorschemes.night
    end

    vim.cmd("colorscheme "..colorscheme)
    require("lualine").setup { options = {
        theme = lualine_colors[colorscheme],
        section_separators = {},
        component_separators = {"|"},
    }}
end

local function setup()
    -- Quick Setup
    setup_colors()
    require("gitsigns").setup()
    require("colorizer").setup()
    require("todo-comments").setup()

    --  Configuration for colorful matching brackets
    --  This plugin doesn't work with Lua or Rust so I'm using two
    --  Rainbow Plugins XD
    vim.g.rainbow_active = 1
    vim.g.rainbow_conf = {
        guifgs = {"Cyan1", "PaleGreen1", "Magenta1", "Gold1"},
        ctermfgs = { 51, 121, 201, 220 }
    }

    -- Haskell Improvements
    vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
    vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
    vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
    vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
    vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
    vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
    vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

    -- Indenting
    vim.g.indent_blankline_char = "│"
    -- Colored indents
    -- vim.cmd [[highlight Indent1 guifg=#88C0D0 guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight Indent2 guifg=#8FBCBB guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight Indent3 guifg=#81A1C1 guibg=NONE gui=nocombine]]
    -- vim.g.indent_blankline_char_highlight_list = { "Indent1", "Indent2", "Indent3" }

    -- Terminal Stuff
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    map("n <C-t>        :FloatermToggle<Enter>")
    map("t <C-t>        <C-\\><C-n>:FloatermToggle<Enter>")
    map("t <C-n>        <C-\\><C-n>:FloatermNext<Enter>")
    map("t <C-p>        <C-\\><C-n>:FloatermPrev<Enter>")
    map("t <C-q>        <C-\\><C-n>:FloatermKill<Enter>")
    map("t <C-t><C-n>   <C-\\><C-n>:FloatermNew<Enter>")

    -- Which Key (Hotkey reminders)
    local wk = require("which-key")
    wk.setup()
    wk.register({
        ["/"]       = "Fuzzy Find",
        f = {
            name    = "Find (Telescope)",
            a       = "All Built-in Telescope Pickers",
            b       = "Buffers",
            e       = "Explorer (Files)",
            f       = "Files",
            g       = "Grep Project",
            h       = "Help (From Vim)",
            m       = "Man Page",
            t       = "Treesitter Symbols",
            T       = "TODO Plugin",
            c = {
                name    = "Code (LSP)",
                a       = "Actions",
                d       = "Definitions",
                D       = "Diagnostics",
                i       = "Implementations",
                r       = "References",
                s       = "Symbols"
            }
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
        h = { name  = "Git Signs" },
        z = { name  = "Zen Mode" },
        c = {
            name = "Code",
            a    = "Action",
            f    = "Format",
            h    = "Help (Hover Docs)",
            s    = "Signature",
            ["-"] = "Comment Banner (--)",
            ["="] = "Comment Banner (==)",
            ["/"] = "Comment Banner (//)",
        },
    }, { prefix     = "<Leader>" })
end

return { setup = setup }