local config = function()
    local gitsigns = require("gitsigns")
    local wk = require("which-key")
    gitsigns.setup({
        current_line_blame_opts = { virt_text_pos = "right_align", delay = 100 },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary> ",
    })
    wk.add({
        { "<Leader>g", group = "git" },
        { "<Leader>gs", ":Telescope git_status<Enter>", desc = "status" },
        {
            "<Leader>gb",
            ":Gitsigns blame_line<Enter>",
            desc = "blame line",
        },
        {
            "<Leader>gB",
            ":Gitsigns toggle_current_line_blame<Enter>",
            desc = "toggle blame line",
        },
        {
            "<Leader>gd",
            ":Gitsigns toggle_deleted<Enter>",
            desc = "toggle deleted",
        },
        {
            "<Leader>gd",
            ":Gitsigns toggle_deleted<Enter>",
            desc = "toggle deleted",
        },
        {
            "<Leader>gp",
            ":Gitsigns preview_hunk<Enter>",
            desc = "preview hunk",
        },
        {
            "<Leader>gr",
            ":Gitsigns reset_hunk<Enter>",
            desc = "reset hunk (DANGER!!)",
        },
    })
end

local lazy_spec = { { "lewis6991/gitsigns.nvim", config = config } }

return lazy_spec
