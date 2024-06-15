local config = function()
    local gitsigns = require("gitsigns")
    local which_key = require("which-key")
    gitsigns.setup({
        current_line_blame_opts = { virt_text_pos = "right_align", delay = 100 },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary> ",
    })
    return which_key.register({
        ["<Leader>"] = {
            g = {
                name = "(g)it",
                s = { ":Telescope git_status<Enter>", "(g)it (s)tatus" },
                b = { ":Gitsigns blame_line<Enter>", "(g)it (b)lame line" },
                B = {
                    ":Gitsigns toggle_current_line_blame<Enter>",
                    "toggle (g)it (B)lame line",
                },
                d = { ":Gitsigns toggle_deleted<Enter>", "(g)it toggle (D)eleted" },
                p = { ":Gitsigns preview_hunk<Enter>", "(g)it (p)review hunk" },
                r = { ":Gitsigns reset_hunk<Enter>", "(g)it (R)eset hunk (DANGER!!!)" },
            },
        },
    })
end

local lazy_spec = { { "lewis6991/gitsigns.nvim", config = config } }

return lazy_spec
