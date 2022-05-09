-- Remaking my config based off of the starter lua config @ https://github.com/nvim-lua/kickstart.nvim

--[[ TODO:
- Organize configuration order!
- Make Starter not highlight the 80th line (../init.vim has highlight groups)
- Configure Neovide Variables (Move from ../init.vim)
    - Make sure multigrid is enabled for Windows
- See if I can bring most of my Obsidian Workflow into Vim
- Check out if some of the Mini.nvim plugins will suit my needs
    - Surround and pairs are acting up in some fairly common cases so
      I need to checkout that.
- Add autocommand to disable git blame on small columns
]]

-- Nord Palette Reference
-- nord1:   #2E3440
-- nord2:   #3B4252
-- nord3:   #434C5E
-- nord4:   #4C566A
-- nord5:   #D8DEE9
-- nord6:   #E5E9F0
-- nord7:   #ECEFF4
-- nord8:   #8FBCBB
-- nord9:   #88C0D0
-- nord10:  #81A1C1
-- nord11:  #5E81AC
-- nord12:  #BF616A
-- nord13:  #D08770
-- nord14:  #EBCB8B
-- nord15:  #A3BE8C
-- nord16:  #B48EAD

function dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k,v in pairs(o) do
            if type(k) ~= "number" then k = "\""..k.."\"" end
            s = s .. "["..k.."] = " .. dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

--- Retrieve Current Time
--- @return table Table with Hour, Minute, and Formatted String
local function get_time(format)
    local format_table = {
        weekday_short = "%a",
        weekday = "%A",
        month_name_short = "%b",
        month_name = "%B",
        day = "%d",
        hour_12 = "%I",
        hour = "%H",
        minute = "%M",
        am_pm = "%p",
        month = "%m",
        second = "%S",
        weekday_num = "%w",
        date = "%x",
        time = "%X",
        year = "%Y",
        year_short = "%y",
    }

    if format ~= nil and format ~= "" then
        if format == "HELP" then
            return format_table
        end
        return os.date(format)
    end
    return {
        hour = tonumber(os.date("%H")),
        minute = tonumber(os.date("%M")),
        second = tonumber(os.date("%S")),
        my_date = os.date("%Y-%m-%dT%H:%M:%S"),
        format = os.date,
    }
end
GetTime = get_time -- Make get_time global
vim.api.nvim_create_user_command("GetTime", function(info)
    print(dump(get_time(info.args)))
end, {}) -- For now, you need to wrap in quotes

local function get_my_date()
    return get_time("%Y-%m-%dT%H:%M:%S")
end

--- Retrieve Day Status
--- @return boolean
local function is_day()
    local hour = get_time().hour
    return hour > 6 and hour < 18
end

local is_startup = vim.v.vim_did_enter == 0
local is_neovide = vim.g.neovide ~= nil

-- Install packer
local packer_bootstrap
local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
      "git", "clone", "--depth", "1",
      "https://github.com/wbthomason/packer.nvim", install_path
  })
  vim.api.nvim_command("packadd packer.nvim")
end

-- This is for auto-sourcing
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "source <afile> | PackerCompile", group = packer_group, pattern = "init.lua" })

local packer = require("packer")

packer.startup(function(use)
    use "wbthomason/packer.nvim"
    use "dstein64/vim-startuptime" -- Run vim w/ `--startuptime`

    -- Common Dependencies
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"
    use "kyazdani42/nvim-web-devicons"

    -- Quality of Life
    use "mattn/emmet-vim"
    use "tpope/vim-repeat"
    use "monaqa/dial.nvim"
    use "nacro90/numb.nvim"
    use "wellle/targets.vim"
    use "wellle/context.vim"
    use "jghauser/mkdir.nvim"
    use "abecodes/tabout.nvim"
    use "voldikss/vim-floaterm"
    use "echasnovski/mini.nvim"
    use "rafcamlet/nvim-luapad"
    use "TimUntersberger/neogit"
    -- use "ggandor/lightspeed.nvim"
    use "ggandor/leap.nvim" -- Trying this out over lightspeed and I like it so far
    use "kyazdani42/nvim-tree.lua"

    -- Pretty Things
    use "edluffy/specs.nvim"
    use "rcarriga/nvim-notify"
    use "shaunsingh/nord.nvim"
    use "p00f/nvim-ts-rainbow"
    use "rmehri01/onenord.nvim"
    use "stevearc/dressing.nvim"
    use "lewis6991/gitsigns.nvim"
    -- use "arcticicestudio/nord-vim"
    use "sainnhe/gruvbox-material"
    use "folke/todo-comments.nvim"
    use "nvim-lualine/lualine.nvim"
    use "neovimhaskell/haskell-vim"
    use "haringsrob/nvim_context_vt"
    use "norcalli/nvim-colorizer.lua"
    use "akinsho/nvim-bufferline.lua"

    -- Writing
    use "lervag/wiki.vim"
    use "godlygeek/tabular"
    use "folke/zen-mode.nvim"
    use "preservim/vim-markdown"

    -- Finders
    use "folke/which-key.nvim"
    use "tversteeg/registers.nvim"
    use "nvim-telescope/telescope.nvim"
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

    -- Treesitter
    use "lewis6991/spellsitter.nvim"
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/nvim-treesitter-refactor"
    use "nvim-treesitter/nvim-treesitter-textobjects"

    -- LSP
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"
    use "williamboman/nvim-lsp-installer"

    -- Completion
    use "L3MON4D3/LuaSnip"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-path"
    use "f3fora/cmp-spell"
    use "hrsh7th/cmp-emoji"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-nvim-lsp"
    use "uga-rosa/cmp-dictionary"
    use "saadparwaiz1/cmp_luasnip"

    if packer_bootstrap then
        packer.sync()
    end
end)

-- Which Key (Mapping reminders)
local wk = require("which-key")
wk.setup()

-- Line Peeking
require("numb").setup()

-- Context
require("nvim_context_vt").setup({})
vim.g.context_add_mappings = 0
vim.cmd[[
if !exists('##WinScrolled')
    nnoremap <silent> <expr> <C-Y> context#util#map('<C-Y>')
    nnoremap <silent> <expr> <C-E> context#util#map('<C-E>')
    nnoremap <silent> <expr> zz    context#util#map('zz')
    nnoremap <silent> <expr> zb    context#util#map('zb')
endif

nnoremap <silent> <expr> zt context#util#map_zt()
]]

-- Tabout
require("tabout").setup({
    act_as_shift_tab = true,
})

-- Leap Movement
require("leap").setup({
    special_keys = {
        repeat_search = "<Enter>",
        next_match    = ";",
        prev_match    = ",",
        next_group    = "<Space>",
        prev_group    = "<Tab>",
        eol           = "<Space>",
    },
})
require("leap").set_default_keymaps()

vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), {noremap = true})
vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), {noremap = true})
vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), {noremap = true})
vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), {noremap = true})
vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), {noremap = true})
vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), {noremap = true})

local augend = require("dial.augend")
require("dial.config").augends:register_group({
    default = {
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.integer.alias.binary,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.integer.alias.decimal,
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.ja_weekday_full,
        augend.constant.new{ elements = {"let", "const"} },
    },
    visual = {
        augend.integer.alias.hex,
        augend.constant.alias.bool,
        augend.integer.alias.binary,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.integer.alias.decimal,
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.ja_weekday_full,
        augend.constant.new{ elements = {"let", "const"} },
    },
})

-- Gitsigns (Sidebar Git Indicators)
require("gitsigns").setup {
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 100,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary> ",
}
wk.register({
    ["<Leader>"] = {
        g = {
            name = "(g)it",
            b = { ":Gitsigns blame_line<Enter>", "(g)it (b)lame line" },
            d = { ":Gitsigns diffthis<Enter>", "(g)it (d)iff" },
            D = { ":Gitsigns toggle_deleted<Enter>", "(g)it toggle (D)eleted" },
            p = { ":Gitsigns preview_hunk<Enter>", "(g)it (p)review hunk" },
            RRR = { ":Gitsigns reset_hunk<Enter>", "(g)it (R)eset hunk (DANGER!!!)" },
        },
    },
})

-- Git Porcelain for Neovim
require("neogit").setup({
    kind = "vsplit",
    mappings = {
        status = {
            ["<Escape>"] = "Close",
        },
    },
})
wk.register({["<Leader>gg"] = { ":Neogit<Enter>", "(g)it Neo(g)it" }})

-- Color Previews in Code
require("colorizer").setup({"*"}, {
    RGB      = true,
    RRGGBB   = true,
    names    = true,
    RRGGBBAA = true,
    rgb_fn   = true,
    hsl_fn   = true,
    css      = true,
    css_fn   = true,
    mode     = "background",
})

-- Fancy TODO Highlighting
if is_startup then
    require("todo-comments").setup()
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

-- Select day/night colorscheme
local colorschemes = { day = "gruvbox-material", night = "nord" }
local colorscheme
if false and is_day() then
    colorscheme = colorschemes.day
    vim.cmd[[set background=light]]
else
    vim.cmd[[set background=dark]]
    colorscheme = colorschemes.night
end

-- Set Colorscheme
vim.cmd("colorscheme " .. colorscheme)
vim.api.nvim_command("highlight NonText guifg=#6C768A")

-- Set Status Bar
require("lualine").setup {
    options = {
        icons_enabled = true,
        component_separators = "|",
        section_separators = "",
    },
}

-- UI "Dressing"
require("dressing").setup()

-- Fancy Notifications
require("notify").setup({
    stages = "slide",
    timeout = 3000
})
vim.notify = require("notify")

-- Haskell Improvements
vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

-- Markdown Improvements
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_strikethrough = 1
vim.g.vim_markdown_auto_insert_bullets = 0
vim.g.vim_markdown_new_list_item_indent = 0

-- Floating Terminal Stuff
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
-- Mapping in terminal mode is a bit weird in which-key right now
local clean = function (mapping)
    return vim.api.nvim_replace_termcodes(mapping, true, true, true)
end
wk.register({["<C-t>"] = { ":FloatermToggle<Enter>", "Open Terminal" }});
wk.register({
    ["<C-t>"] = { clean("<C-\\><C-n>:FloatermToggle<Enter>"), "Close Terminal" },
    ["<C-n>"] = { clean("<C-\\><C-n>:FloatermNext<Enter>"), "Go To Next Terminal" },
    ["<C-p>"] = { clean("<C-\\><C-n>:FloatermPrev<Enter>"), "Go To Previous Terminal" },
    ["<C-q>"] = { clean("<C-\\><C-n>:FloatermKill<Enter>"), "Quit/Kill The Current Terminal" },
    ["<C-t><C-n>"] = { clean("<C-\\><C-n>:FloatermNew<Enter>"), "Create New Terminal" },
}, { mode = "t" });

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Telescope
local actions = require("telescope.actions")
require("telescope").setup {
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
    }
}
wk.register({
    ["<Leader>"] = {
        f = {
            name = "(f)ind something (Telescope Pickers)",
            a = { ":Telescope<Enter>", "(a)ll built in pickers" },
            b = { ":Telescope buffers<Enter>", "(b)uffers" },
            c = { [[<CMD>lua require("telescope.builtin").commands()<Enter>]], "(c)ommands" }, -- OKAY WTFRIK. Colon works except here. I'm confused
            d = { ":Telescope diagnostics<Enter>", "(d)iagnostics" },
            f = { ":Telescope find_files<Enter>", "(f)iles" },
            g = { ":Telescope live_grep<Enter>", "(g)rep project" },
            h = { ":Telescope help_tags<Enter>", "(h)elp" },
            m = { ":Telescope man_pages<Enter>", "(m)an pages" },
            r = { ":Telescope oldfiles<Enter>", "(r)ecent files" },
            t = { ":TodoTelescope<Enter>", "(t)odo plugin telescope" },
            T = { ":Telescope treesitter<Enter>", "(T)reesitter symbols" },
        },
        ["/"] = { ":Telescope current_buffer_fuzzy_find<Enter>", "Fuzzy Find In File" },
        ["?"] = { ":Telescope live_grep<Enter>", "Fuzzy Find Across Project" },
    },
    gr = { ":Telescope lsp_references<Enter>", "Find References" },
    ["z="] = { ":Telescope spell_suggest<Enter>", "Spelling Suggestions" },
});
require("telescope").load_extension("fzf")

-- Treesitter configuration
require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "c", "lua", "rust", "bash", "clojure", "cmake",
        "css", "commonlisp", "erlang", "fennel", "go",
        "glsl", "haskell", "java", "html", "http",
        "javascript", "json", "latex", "make", "markdown",
        "ocaml", "python", "regex", "scheme", "svelte",
        "swift", "toml", "vim", "yaml", "wgsl", "tsx",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true, -- WARN: Decide to keep or not
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
    indent = { enable = true },
    refactor = {
        -- highlight_current_scope = { enable = true },
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Leader>trn",
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
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
}
require("spellsitter").setup()

-- LSP setup
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
    vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})

    wk.register({
        g = {
            name = "(g)o to",
            d = { vim.lsp.buf.definition, "(g)o to (d)efinition" },
            D = { vim.lsp.buf.declaration, "(g)o to (D)eclaration" },
            i = { vim.lsp.buf.implementation, "(g)o to (i)mplementation" },
            r = { vim.lsp.buf.references, "(g)o to (r)eferences" },
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lsp_settings = {
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = runtime_path },
                diagnostics = { globals = { "vim" } },
                -- Make the server aware of Neovim runtime files
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            },
        },
    }
}

if is_startup then -- Only load LSPs on startup
    for _, server in ipairs(lsp_servers) do
        local setup = {}
        if lsp_settings[server] ~= nil then
            setup = lsp_settings[server]
        end
        setup.on_attach = on_attach
        setup.capabilities = capabilities
        require("lspconfig")[server].setup(setup)
    end
end

require("lsp_signature").setup({
    hint_enable = true,
    hint_prefix = "✅ "
})

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup {
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
            { name = "luasnip" },
            { name = "nvim_lsp" },
            { name = "emoji", option = { insert = true } },
        },
        {
            { name = "path" },
            { name = "spell" },
            { name = "buffer" },
            { name = "dictionary" },
        }
    ),
}

-- Automatically make directory upon save
require("mkdir")

-- mini.nvim (Collection of Plugins) Setup
require("mini.cursorword").setup({ delay = 500 })
require("mini.trailspace").setup({})
-- Disable Trailing Space Highlights in Certain Buffers
vim.api.nvim_create_autocmd({"BufEnter"}, {
    callback = function()
        local bufferName = vim.api.nvim_eval[[bufname()]]
        local tabPageNumber = vim.api.nvim_eval[[tabpagenr()]]
        if bufferName == "NvimTree_" .. tabPageNumber then
            require("mini.trailspace").unhighlight()
        end
    end,
})
-- Trim Space on Save
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    callback = function()
        require("mini.trailspace").trim()
    end,
})
require("mini.comment").setup({})
require("mini.indentscope").setup({
    symbol = "⟫",
})
vim.api.nvim_command[[highlight Delimiter guifg=#4C566A]] -- Make Delimiters Less Obtrusive
require("mini.pairs").setup({})
require("mini.starter").setup({
    header =[[
__      __          _                                              _  __  __   __
\ \    / / ___     | |     __      ___    _ __     ___      o O O | |/ /  \ \ / /
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o      | ' <    \ V /
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O] |_|\_\   _\_/_
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======|_|"""""|_| """"|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-']],
})
require("mini.sessions").setup({}) -- This doesn't work on Windows for some reason
require("mini.surround").setup({
    custom_surroundings = {
        ["|"] = { output = { left = "|", right = "|" }},
    },
    -- TODO: Think About This
    -- WARNING: THINK ABOUT IT VERY CAREFULLY
    mappings = {
        add = "ys",
        delete = "ds",
        find = "gS",
        find_left = "gs",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
    },
    n_lines = 100,
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
    ["<Leader>bc"] = { ":bd<Enter>", "(b)uffer (c)lose" },
    ["<M-l>"] = { ":BufferLineCycleNext<Enter>", "buffer next" },
    ["<M-h>"] = { ":BufferLineCyclePrev<Enter>", "buffer prev" },
    ["<Leader>bl"] = { ":BufferLineCycleNext<Enter>", "(b)uffer next" },
    ["<Leader>bh"] = { ":BufferLineCyclePrev<Enter>", "(b)uffer prev" },
    ["<M-j>"] = { ":BufferLineMoveNext<Enter>", "buffer move next" },
    ["<M-k>"] = { ":BufferLineMovePrev<Enter>", "buffer move prev" },
    ["<Leader>bj"] = { ":BufferLineMoveNext<Enter>", "(b)uffer move next" },
    ["<Leader>bk"] = { ":BufferLineMovePrev<Enter>", "(b)uffer move prev" },
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

-- Wiki Vim
vim.g.wiki_mappings_use_defaults = "none"
vim.g.wiki_root = "~/Documents/Notes"
vim.g.wiki_link_extension = ".md"
vim.g.wiki_filetypes = { "md", "markdown" }
vim.g.wiki_journal = {
    name = "Journal",
    frequency = "daily",
    date_format = {
        daily = "%Y-%m-%d"
    }
}
vim.g.wiki_index_name = "- Index -.md"
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.md", "*.mdx", "*.txt", "*.wiki" },
    callback = function(eventInfo)
        wk.register({
            ["<Leader>ww"] = { "<Plug>(wiki-index)", "(w)iki (w)iki-index" },
            ["<Enter>"] = { "<Plug>(wiki-link-follow)", "Go To Wiki Link" },
            ["<Leader>wb"] = { "<Plug>(wiki-graph-find-backlinks)", "(w)iki (b)acklinks" },
        }, { buffer = eventInfo.buf });
    end
})

-- Lua Pad (Quick Lua Testing)
require("luapad").config { count_limit = 50000 }

-- Lightspeed Setup (Allows for repeat searches with ; and ,)
-- vim.cmd [[
--     let g:lightspeed_last_motion = ""
--     augroup lightspeed_last_motion
--     autocmd!
--     autocmd User LightspeedSxEnter let g:lightspeed_last_motion = "sx"
--     autocmd User LightspeedFtEnter let g:lightspeed_last_motion = "ft"
--     augroup end
--     map <expr> ; g:lightspeed_last_motion == "sx" ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
--     map <expr> , g:lightspeed_last_motion == "sx" ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
-- ]]

-- Zen Mode (Minimal Mode)
require("zen-mode").setup {
    window = { width = 88, number = true },
    plugins = { options = { ruler = true }},
    gitsigns = { enable = true },
    on_open = function() end,
    on_close = function() end
}
wk.register({
    ["<Leader>z"] = { ":ZenMode<Enter>", "(z)en mode" },
});

-- Misc Mappings
wk.register({
    s = {
        name    = "Spelling",
        a       = "Add to Dictionary",
        r       = "Remove from Dictionary",
        u       = "Undo Last Dictionary Action"
    },
    w = { name = "(w)indow (Ctrl-w)" },
    c = {
        ["-"] = "Comment Banner (--)",
        ["="] = "Comment Banner (==)",
        ["/"] = "Comment Banner (//)",
    },
}, { prefix     = "<Leader>" })
