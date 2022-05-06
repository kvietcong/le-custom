local map = require("helpers").map

local function setup()
    require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        rainbow = {
            enable = true,
            extended_mode = true,
        },
        refactor = {
            highlight_definitions = { enable = true },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "<Leader>trn",
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "gd",
                    goto_next_usage = "g>",
                    goto_previous_usage = "g<",
                }
            },
            -- TODO: Find out why custom text objects are not working
            -- Today (5/5/2022) I found out why. I put it under refacotor 🤦
            textobjects = {
                lsp_interop = { enable = true },
                select = {
                    enable = true,
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
                        ["<Leader>cs"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<Leader>cs"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = { ["]]"] = "@function.outer" },
                    goto_next_end = { ["]}"] = "@function.outer" },
                    goto_previous_start = { ["[["] = "@function.outer" },
                    goto_previous_end = { ["[{"] = "@function.outer" },
                }
            }
        }
    }

    require("zen-mode").setup {
        window = { width = 88, number = true },
        plugins = { options = { ruler = true }},
        gitsigns = { enable = true },
        on_open = function() end,
        on_close = function() end
    }
    map("n <Leader>z :ZenMode<Enter>")
end

return { setup = setup }
