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
        section_separators = "",
        component_separators = "|",
    }}
end

local function setup()
    -- Quick Setup
    setup_colors()
    require("gitsigns").setup()
    require("colorizer").setup()
    require("todo-comments").setup()

    -- Neogit
    require("neogit").setup()
    map("n <Leader>gg :Neogit<Enter>")

    --  Configuration for colorful matching brackets
    --  This plugin doesn't work with Lua or Rust so I'm using two
    --  Rainbow Plugins XD
    vim.g.rainbow_active = 1

    -- Haskell Improvements
    vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
    vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
    vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
    vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
    vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
    vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
    vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

    -- Indent blankline
    vim.opt.list = true
    vim.opt.listchars:append("space:⋅")
    vim.opt.listchars:append("eol:↴")
    require("indent_blankline").setup {
        char = "┊",
        show_current_context_start = true,
        show_trailing_blankline_indent = true,
        space_char_blankline = " ",
    }

    require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
    }

    -- Terminal Stuff
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    map("n <C-t>        :FloatermToggle<Enter>")
    map("t <C-t>        <C-\\><C-n>:FloatermToggle<Enter>")
    map("t <C-n>        <C-\\><C-n>:FloatermNext<Enter>")
    map("t <C-p>        <C-\\><C-n>:FloatermPrev<Enter>")
    map("t <C-q>        <C-\\><C-n>:FloatermKill<Enter>")
    map("t <C-t><C-n>   <C-\\><C-n>:FloatermNew<Enter>")

    -- Markdown
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_folding_level = 6
    vim.g.vim_markdown_auto_insert_bullets = 0
    vim.g.vim_markdown_new_list_item_indent = 0
    vim.g.vim_markdown_override_folding_text = 1

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
            r       = "Recent Files",
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
            k       = "Kill (Delete) Buffer",
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
