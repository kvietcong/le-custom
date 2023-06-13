-------------------
-- Miscellaneous --
-------------------

local whichkey = require("le.which-key")
local lf = require("le.libf")

-- Random FD command XD
vapi.nvim_create_user_command("FD", function(command)
    lf.fd_async({
        args = { command.args },
        callback = P,
    })
end, { nargs = "?" })

-- Create directory on write if it doesn't exist
vapi.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    group = le_group,
    callback = function()
        local filepath = vfn.expand("<afile>")
        if string.match(filepath, "oil") then
            return
        end
        local directory = vfn.fnamemodify(filepath, ":p:h")
        local doesDirectoryExist = vfn.isdirectory(directory)
        if doesDirectoryExist == 0 then
            vfn.mkdir(directory, "p")
        end
    end,
})

-- Trigger autoread manually every second
-- This is so Vim auto-updates files on external change
AutoReadTimer = vfn.timer_start(5000, function()
    vim.cmd([[silent! checktime]])
end, { ["repeat"] = -1 })

-- TODO: move this into it's own file
local oil = require("oil")
oil.setup({
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<Enter>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-p>"] = "actions.preview",
        ["<C-t>"] = "actions.close",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["<C-o>"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["<C-i>"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
    },
    view_options = {
        show_hidden = true,
    },
})
-- TODO: make better keymaps
vim.keymap.set("n", "-", oil.open_float, { desc = "Open oil" })
vim.keymap.set("n", "<C-f>", oil.toggle_float, { desc = "Toggle oil" })
vim.keymap.set("n", "+", oil.close, { desc = "Close oil" })

local parinfer_filetypes = {
    "clojure",
    "scheme",
    "lisp",
    "racket",
    "hy",
    "fennel",
    "janet",
    "carp",
    "wast",
    "yuck",
    "dune",
}
vim.api.nvim_create_autocmd("FileType", {
    pattern = parinfer_filetypes,
    group = le_group,
    callback = function()
            vim.b.minipairs_disable = true
    end,
})
local mini_pairs = require("mini.pairs")
mini_pairs.setup({})
-- TODO: why isn't the closing of anything but parens working?

local mini_comment = require("mini.comment")
mini_comment.setup()

-- Misc Mappings
whichkey.register({
    s = {
        name = "(s)essions",
    },
    ["<Leader>s"] = {
        name = "(s)pelling",
        a = "Add to Dictionary",
        r = "Remove from Dictionary",
        u = "Undo Last Dictionary Action",
        l = "Go to Next Spelling Error",
        h = "Go to Previous Spelling Error",
    },
    w = { name = "(w)indowing (Also Ctrl-w)" },
    c = {
        ["-"] = "Comment Banner (--)",
        ["="] = "Comment Banner (==)",
        ["/"] = "Comment Banner (//)",
        f = { ":Format<Enter>", "(c)ode (f)ormatting" },
    },
    ["<Leader>"] = {
        q = "(q)uit all",
        r = {
            function()
                vim.cmd("source $MYVIMRC")
                lf.notify_info("Configuration Reloaded")
            end,
            "(r)e-source config",
        },
    },
}, { prefix = "<Leader>" })

vapi.nvim_create_autocmd("TextYankPost", {
    group = le_group,
    desc = "Highlight Yanked Text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
})

return true
