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

whichkey.register(
    { gf = { ":Tabularize /", "format using tabular", silent = false } },
    { mode = "v" }
)

vapi.nvim_create_autocmd("TextYankPost", {
    group = le_group,
    desc = "Highlight Yanked Text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
})

return true
