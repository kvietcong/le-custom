local config = function()
    -- [TODO]: Make an option to toggle between float and split
    --      Kill all terms then set vim.g options
    local wk = require("which-key")
    local clean = require("le.lib").clean
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.autoclose = 1
    wk.register({
        ["<C-t>"] = { ":FloatermToggle<Enter>", "Open Terminal" },
    })
    wk.register({
        ["<C-t>"] = { clean("<C-\\><C-n>:FloatermToggle<Enter>"), "Close Terminal" },
        ["<A-l>"] = {
            clean("<C-\\><C-n>:FloatermNext<Enter>"),
            "Go To Next Terminal",
        },
        ["<A-h>"] = {
            clean("<C-\\><C-n>:FloatermPrev<Enter>"),
            "Go To Previous Terminal",
        },
        ["<A-q>"] = {
            clean("<C-\\><C-n>:FloatermKill<Enter>:FloatermToggle<Enter>"),
            "Quit/Kill The Current Terminal",
        },
        ["<A-n>"] = {
            clean("<C-\\><C-n>:FloatermNew<Enter>"),
            "Create New Terminal",
        },
    }, { mode = "t" })
    wk.register({
        ["<C-t>"] = {
            ":FloatermSend<Enter>:FloatermShow<Enter>",
            "Send Lines to Terminal",
        },
    }, { mode = "v" })
end

local lazy_spec = { { "voldikss/vim-floaterm", config = config } }

return lazy_spec
