local config = function()
    local lib = require("le.lib")
    local get_is_disabled = function(
        _, --[[ filetype ]]
        buf_number
    )
        return lib.get_is_thicc_buffer(buf_number)
    end

    vim.treesitter.language.register("racket", "scheme")
    vim.filetype.add({ extension = { wgsl = "wgsl" } })

    require("nvim-treesitter.configs").setup({
        -- ensure_installed = "all", -- "all" makes startup times much worse. Only uncomment for bootstrapping
        ensure_installed = {},
        ignore_install = { "phpdoc" },
        auto_install = false,
        sync_install = false,
        highlight = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Enter>",
                node_incremental = "<Enter>",
                node_decremental = "<Backspace>",
            },
        },
        refactor = {
            -- THESE PLUGINS DESTROY PERFORMANCE ON LARGE FILES
            highlight_definitions = {
                enable = true,
                disable = get_is_disabled,
            },
            smart_rename = {
                enable = true,
                disable = get_is_disabled,
                keymaps = {
                    smart_rename = "<Leader>rn",
                },
            },
            navigation = {
                enable = true,
                disable = get_is_disabled,
                keymaps = {
                    goto_definition_lsp_fallback = "gd",
                    goto_next_usage = "g>",
                    goto_previous_usage = "g<",
                },
            },
        },
        textobjects = {
            lsp_interop = { enable = true },
            disable = get_is_disabled,
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
                    ["ac"] = "@call.outer",
                    ["ic"] = "@call.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ak"] = "@comment.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<Leader>>>"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<Leader><<"] = "@parameter.inner",
                },
            },
        },
    })

    require("rainbow-delimiters.setup").setup({})
end

local lazy_spec = {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = config,
        dependencies = {
            "hiphish/rainbow-delimiters.nvim",
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
    },
}

return lazy_spec
