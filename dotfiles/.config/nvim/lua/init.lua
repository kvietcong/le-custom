-------------------------------------
--=================================--
--== Welcome to Le Neovim Config ==--
--=================================--
-------------------------------------

--[[
[TODO]:
- Report issue that PDF makes telescope crash
- Report which-key issue where "desc" isn't inheritable (can't have multiple keys for one action)
]]

-- EMERGENCY EDITING
vim.api.nvim_set_keymap("n", "<F1>", "", {
    noremap = true,
    silent = true,
    desc = "EMERGENCY EDIT",
    callback = function()
        vim.cmd("e $MYVIMRC")
        vim.cmd("cd %:p:h")
        vim.cmd("e ./lua/init.lua")
    end,
})

require("le.globals")
require("le.bootstrap")
require("lazy").setup("le.plugin_specs", {})
require("le.misc")
