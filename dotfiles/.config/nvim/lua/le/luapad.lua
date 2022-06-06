-- Lua Pad (Quick Lua Testing)
local luapad = require("luapad")
local whichkey = require("le.which-key")

luapad.setup({
    count_limit = 5e4,
    print_highlight = "DiagnosticVirtualTextInfo",
})
vapi.nvim_create_user_command("LuaPad", function()
    vapi.nvim_command([[botright vsplit ~/tmp/luapad.lua]])
    require("luapad.evaluator")
        :new({
            buf = 0,
            context = _G.cfg_env,
        })
        :start()
    vapi.nvim_create_autocmd({ "WinClosed" }, {
        group = le_group,
        desc = "Delete Luapad Buffer on quit",
        buffer = 0,
        callback = function(event)
            vapi.nvim_buf_delete(event.buf, { force = true })
        end,
    })
end, {})
whichkey.register({
    ["<Leader>e"] = {
        name = "(e)valuate",
        p = { ":LuaPad<Enter>", "(e)valuate with lua(p)ad" },
    },
}, {})

return luapad
