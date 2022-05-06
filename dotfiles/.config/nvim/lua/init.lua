-- Remaking my config based off of the starter lua config @ https://github.com/nvim-lua/kickstart.nvim

--- Retrieve Current Time
--- @return table Table with Hour, Minute, and Formatted String
local function get_time()
    return {
        hour = tonumber(os.date("%H")),
        minute = tonumber(os.date("%M")),
        string = os.date("%H:%M")
    }
end

--- Retrieve Day Status
--- @return boolean
local function is_day()
    local hour = get_time().hour
    return hour > 6 and hour < 18
end

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
-- local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", { command = "source <afile> | PackerCompile", group = packer_group, pattern = "init.lua" })

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
    use "tpope/vim-surround"
    use "wellle/targets.vim"
    use "voldikss/vim-floaterm"
    use "numToStr/Comment.nvim"
    use "rafcamlet/nvim-luapad"
    use "TimUntersberger/neogit"
    use "ggandor/lightspeed.nvim"
    use "kyazdani42/nvim-tree.lua"

    -- Pretty Things
    use "luochen1990/rainbow"
    use "shaunsingh/nord.nvim"
    use "p00f/nvim-ts-rainbow"
    use "lewis6991/gitsigns.nvim"
    use "sainnhe/gruvbox-material"
    use "folke/todo-comments.nvim"
    use "nvim-lualine/lualine.nvim"
    use "neovimhaskell/haskell-vim"
    use "norcalli/nvim-colorizer.lua"
    use "akinsho/nvim-bufferline.lua"
    use "lukas-reineke/indent-blankline.nvim"

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

-- Setup Easy Commenting
require("Comment").setup({})

-- Gitsigns (Sidebar Git Indicators)
require("gitsigns").setup()

-- Git Porcelin for Neovim
require("neogit").setup()

-- Color Previews in Code
require("colorizer").setup()

-- Fancy TODO Highlighting
require("todo-comments").setup()

-- Colorscheme Options
vim.g.nord_borders = true
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_diagnostic_virtual_text = 1
vim.g.gruvbox_material_diagnostic_text_highlight = 1
vim.g.gruvbox_material_diagnostic_line_highlight = 1

-- Select day/night colorscheme
local lualine_colors = {
    nord = "nord",
    ["gruvbox-material"] = "gruvbox_light",
}
local colorschemes = { day = "gruvbox-material", night = "nord" }
local colorscheme
if is_day() then
    colorscheme = colorschemes.day
    vim.cmd[[set background=light]]
else
    colorscheme = colorschemes.night
end

-- Set Colorscheme
vim.cmd("colorscheme " .. colorscheme)

-- Set Status Bar
require("lualine").setup { options = {
    icons_enabled = true,
    theme = lualine_colors[colorscheme],
    component_separators = "|",
    section_separators = "",
}}

-- Indent blankline
require("indent_blankline").setup {
    char = "┊",
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = true,
}

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
            d = { ":Telescope diagnostics<Enter>", "[d]iagnostics" },
            E = { ":Telescope emoji<Enter>", "[E]mojis ✨" },
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
    highlight = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
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
            name = "[g]o to",
            d = { vim.lsp.buf.definition, "[g]o to [d]efinition" },
            D = { vim.lsp.buf.declaration, "[g]o to [D]eclaration" },
            i = { vim.lsp.buf.implementation, "[g]o to [i]mplementation" },
            r = { vim.lsp.buf.references, "[g]o to [r]eferences" },
        },
        ["<Leader>"] = {
            c = {
                name = "[c]ode",
                a = { vim.lsp.buf.code_action, "[c]ode [a]ction" },
                f = { vim.lsp.buf.formatting, "[c]ode [f]ormatting" },
                h = { vim.lsp.buf.hover, "[c]ode [h]over" },
                s = { vim.lsp.buf.signature_help, "[c]ode [s]ignature" },
                t = { vim.lsp.buf.type_definition, "[c]ode [t]ype" },
            },
            fs = { ":Telescope lsp_document_symbols<Enter>", "[s]ymbols" },
            rn = { vim.lsp.buf.rename, "[r]e[n]ame symbol" },
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

for _, server in ipairs(lsp_servers) do
    local setup = {}
    if lsp_settings[server] ~= nil then
        setup = lsp_settings[server]
    end
    setup.on_attach = on_attach
    setup.capabilities = capabilities
    require("lspconfig")[server].setup(setup)
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
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
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

-- Bufferline (Easy Tabs)
require("bufferline").setup { options = {
    show_close_icon = false,
    diagnostics = "nvim_lsp",
    seperator_style = "thick"
}}
wk.register({
    ["<Leader>bk"] = { ":bd<Enter>", "[b]uffer [k]ill" },
    ["<M-l>"] = { ":BufferLineCycleNext<Enter>", "buffer next" },
    ["<M-h>"] = { ":BufferLineCyclePrev<Enter>", "buffer prev" },
    ["<Leader>bn"] = { ":BufferLineCycleNext<Enter>", "[b]uffer [n]ext" },
    ["<Leader>bp"] = { ":BufferLineCyclePrev<Enter>", "[b]uffer [p]rev" },
    ["<M-j>"] = { ":BufferLineMoveNext<Enter>", "buffer move next" },
    ["<M-k>"] = { ":BufferLineMovePrev<Enter>", "buffer move prev" },
    ["<Leader>bmn"] = { ":BufferLineMoveNext<Enter>", "[b]uffer [m]ove [n]ext" },
    ["<Leader>bmp"] = { ":BufferLineMovePrev<Enter>", "[b]uffer [m]ove [p]rev" },
});

-- Neovim tree (File explorer)
require("nvim-tree").setup()
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1
wk.register({
    ["<Leader>fe"] = { ":NvimTreeToggle<Enter>", "[f]ile [e]xplorer ([f]ind [e]xplorer)"
}});

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
            ["<Leader>ww"] = { "<Plug>(wiki-index)", "[w]iki [w]iki-index" },
            ["<Enter>"] = { "<Plug>(wiki-link-follow)", "Go To Wiki Link" },
            ["<Leader>wb"] = { "<Plug>(wiki-graph-find-backlinks)", "[w]iki [b]acklinks" },
        }, { buffer = eventInfo.buf });
    end
})

-- Lua Pad (Quick Lua Testing)
require("luapad").config { count_limit = 50000 }

-- Lightspeed Setup (Allows for repeat searches with ; and ,)
vim.cmd [[
    let g:lightspeed_last_motion = ""
    augroup lightspeed_last_motion
    autocmd!
    autocmd User LightspeedSxEnter let g:lightspeed_last_motion = "sx"
    autocmd User LightspeedFtEnter let g:lightspeed_last_motion = "ft"
    augroup end
    map <expr> ; g:lightspeed_last_motion == "sx" ? "<Plug>Lightspeed_;_sx" : "<Plug>Lightspeed_;_ft"
    map <expr> , g:lightspeed_last_motion == "sx" ? "<Plug>Lightspeed_,_sx" : "<Plug>Lightspeed_,_ft"
]]

-- Zen Mode (Minimal Mode)
require("zen-mode").setup {
    window = { width = 88, number = true },
    plugins = { options = { ruler = true }},
    gitsigns = { enable = true },
    on_open = function() end,
    on_close = function() end
}
wk.register({
    ["<Leader>z"] = { ":ZenMode<Enter>", "[z]en mode" },
});

-- Misc Mappings
wk.register({
    s = {
        name    = "Spelling",
        a       = "Add to Dictionary",
        r       = "Remove from Dictionary",
        u       = "Undo Last Dictionary Action"
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
