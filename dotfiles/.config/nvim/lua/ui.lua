local map = require("helpers").map

local function setup()
    -- Quick UI Plugin Setup
    require("gitsigns").setup()
    require("colorizer").setup()
    require("todo-comments").setup()

    -- Color Scheme/Status Line
    vim.g.nord_borders = true
    require("nord").set()
    require("lualine").setup { options = {
        theme = "nord",
        section_separators = {},
        component_separators = {"|"},
    }}

    -- Haskell Improvements
    vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
    vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
    vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
    vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
    vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
    vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
    vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

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

    -- Transparency
    require("transparent").setup({ enable = true })
    map("n <Leader>t :TransparentToggle<Enter>")

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
end

local ui = {}
ui.setup = setup
return ui
