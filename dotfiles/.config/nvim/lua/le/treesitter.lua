-------------------------
-- Treesitter Setup 🌳 --
-------------------------

local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
ft_to_parser.racket = "scheme"

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        disable = { "markdown" },
        additional_vim_regex_highlighting = { "markdown" },
    },
    context_commentstring = { enable = true },
    ensure_installed = "all",
    ignore_install = { "phpdoc" },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = { -- TODO: Look more at these
            init_selection = [[\\ti]],
            node_incremental = [[\\tk]],
            scope_incremental = [[\\tK]],
            node_decremental = [[\\tj]],
        },
    },
    refactor = {
        -- highlight_current_scope = { enable = true },
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
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
            },
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
                ["a?"] = "@conditional.outer",
                ["i?"] = "@conditional.inner",
                ["aC"] = "@call.outer",
                ["iC"] = "@call.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aP"] = "@parameter.outer",
                ["iP"] = "@parameter.inner",
                ["ak"] = "@comment.outer",
                ["as"] = "@statement.outer",
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

return true
