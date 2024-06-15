local config = function()
    local which_key = require("which-key")
    local _local_1_ = require("le.libf")
    local clean = _local_1_["clean"]
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.autolose = 1
    which_key.register({ ["<C-t>"] = { ":FloatermToggle<Enter>", "Open Terminal" } })
    which_key.register(
        {
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
        },
        { mode = "t" }
    )
    return which_key.register(
        {
            ["<C-t>"] = {
                ":FloatermSend<Enter>:FloatermShow<Enter>",
                "Send Lines to Terminal",
            },
        },
        { mode = "v" }
    )
end

local lazy_spec = { { "voldikss/vim-floaterm", config = config } }

return lazy_spec
