local map = require("helpers").map

local function setup()
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
                    smart_rename = "gr",
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "gd",
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
    map("n <Leader>z :ZenMode<Enter>")
    require("twilight").setup()
end

local treesitter = {}
treesitter.setup = setup
return treesitter
