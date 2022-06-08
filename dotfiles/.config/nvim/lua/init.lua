-------------------------------------
--=================================--
--== Welcome to Le Neovim Config ==--
--=================================--
-------------------------------------

--[[ TODO: General Configuration Things
- Find out why Windows emoji selector doesn't work with Neovide
- See if I can bring most of my Obsidian Workflow into Vim
- Check out :help ins-completion
- Sort out nvim-cmp sources!
- Find a way to make it not lag on LARGE files (look at init.lua for telescope-emoji)
- Learn how tabs work in Vim
- Find out why I get a weird once in a while fold bug
- Check if every required executable is installed w/ vfn.executable
- Remove the need for wiki.vim. It also seems to have stopped working for me :(
]]

--------------------------
-- Setting Things Up 🔧 --
--------------------------

-- EMERGENCY
vim.api.nvim_set_keymap("n", "<F1>", "", {
    noremap = true,
    silent = true,
    desc = "EMERGENCY EDIT",
    callback = function()
        vim.cmd("e $MYVIMRC")
        vim.cmd("cd %:p:h")
        vim.cmd("e ./lua/le/libl.lua")
        vim.cmd("e ./fnl/le/libf.fnl")
        vim.cmd("e ./lua/init.lua")
    end,
})

-- Make built-in functions easier to access
_G.vfn = vim.fn
_G.vapi = vim.api

-- Shortcuts to Table Functions
_G.t = {
    filter = vim.tbl_filter,
    contains = vim.tbl_contains,
    map = vim.tbl_map,
    count = vim.tbl_count,
    extend = vim.tbl_extend,
    deep_extend = vim.tbl_deep_extend,
    isempty = vim.tbl_isempty,
    add_reverse_lookup = vim.tbl_add_reverse_lookup,
    get = vim.tbl_get,
    values = vim.tbl_values,
    keys = vim.tbl_keys,
    flatten = vim.tbl_flatten,
    islist = vim.tbl_islist,
    range = vfn.range,
}
_G.t = vim.tbl_extend("force", table, _G.t)

-- Metatable shenanigans
local String = getmetatable("")
function String.__index:char_at(i)
    if i > #self then
        return nil
    end
    return self:sub(i, i)
end

-- Globally helpful things
_G.P = function(...)
    vim.pretty_print(...)
end
_G.PR = function(...)
    P(...)
    return ...
end

-- Ensure old timers are cleaned upon reloading
if not is_startup then
    vfn.timer_stopall()
end

-- Autocommand group for configuration
_G.le_group = vapi.nvim_create_augroup("LeConfiguration", { clear = true })
_G["le-group"] = _G.le_group

-- Helpful Flags and Variables
_G.is_startup = vfn.has("vim_starting") == 1
_G.is_neovide = vim.g.neovide ~= nil
_G.is_nvui = vim.g.nvui ~= nil
_G.is_fvim = vim.g.fvim_loaded
_G.is_goneovim = vim.g.goneovim
_G.is_firenvim = vim.g.started_by_firenvim or false
_G.is_gui = is_neovide or is_nvui or is_fvim or is_goneovim or is_firenvim
_G.is_mac = vfn.has("mac") == 1
_G.is_wsl = vfn.has("wsl") == 1
_G.is_win = vfn.has("win32") == 1
-- local is_unix = fn.has("unix") == 1
-- local is_linux = fn.has("linux") == 1
_G.is_dev_mode = true
_G.data_path = vfn.stdpath("data"):gsub("\\", "/")
_G.config_path = vfn.stdpath("config"):gsub("\\", "/")
_G.is_going_hard = is_neovide

-- Trigger autoread manually every second
-- This is so Vim auto-updates files on external change
AutoReadTimer = vfn.timer_start(1000, function()
    vim.cmd([[silent! checktime]])
end, { ["repeat"] = -1 })

-- This is for sourcing on configuration change
vapi.nvim_create_autocmd({ "BufWritePost" }, {
    group = le_group,
    pattern = { "init.vim", "*/nvim/lua/*.lua", "*/nvim/fnl/*.fnl" },
    desc = "Auto re-source configuration files.",
    callback = function()
        if is_dev_mode then
            vim.cmd("source $MYVIMRC | PackerCompile")
            vim.notify("Configuration Reloaded", nil, { title = "Info" })
        end
    end,
})

if not is_startup then
    package.loaded["le.packer"] = nil
end
require("le.packer")

-- Allow Fennel to be used
require("hotpot")

-- Load cached plugins for speed
require("impatient").enable_profile()

local plenary = require("plenary")

require("le.hotpot")
require("le.legendary")
require("le.which-key")

-- Force reload specific modules for faster development
if not is_startup then
    plenary.reload.reload_module("le.libf")
    plenary.reload.reload_module("le.libl")
end

-- Load Helper Modules
local lf = require("le.libf") -- My Helper module (Fennel)
-- local ll = require("le.libl") -- My Helper module (Lua)

-- Escaped Strings are Pain in Fennel
DashboardArt = [[
__      __          _                                              _  __  __   __
\ \    / / ___     | |     __      ___    _ __     ___      o O O | |/ /  \ \ / /
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o      | ' <    \ V /
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O] |_|\_\   _\_/_
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======|_|"""""|_| """"|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-']]

local safely_load_module = function(module, will_hard_reload)
    local callback
    if lf.get_is_list(module) then
        callback = module[2]
        module = module[1]
    end
    if will_hard_reload then
        plenary.reload.reload_module(module)
    end
    local is_loading_ok, return_value = pcall(require, module)
    if not is_loading_ok then
        lf.notify_error("Failed to load module: " .. module)
        lf.notify_error(return_value)
    else
        if callback then
            callback(return_value)
        end
    end
end

local safely_load_modules = function(modules, will_hard_reload)
    for _, module in pairs(modules) do
        safely_load_module(module, will_hard_reload)
    end
end

-------------------------
-- Make Neovim Pretty! --
-------------------------

local pretty_modules = {
    "le.gui",
    "le.notify",
    "le.haskell",
    "le.starter",
    "le.dressing",
    "le.colorizer",
    "le.statusline",
    "le.bufferline",
    "le.colorscheme",
    "le.indentscope",
}

safely_load_modules(pretty_modules, not is_startup)

------------------------------
-- Useful Utilities Setup ⚙️ --
------------------------------

local utility_modules = {
    "le.lsp",
    "le.misc",
    "le.leap",
    "le.focus",
    "le.yanky",
    "le.neogit",
    "le.luapad",
    "le.luasnip",
    "le.conjure",
    "le.comment",
    "le.zen-mode",
    "le.winshift",
    "le.gitsigns",
    "le.floaterm",
    "le.fnl-init",
    "le.sessions",
    "le.surround",
    "le.rest-nvim",
    "le.telescope",
    "le.bufremove",
    "le.cursorword",
    "le.trailspace",
    "le.treesitter",
    "le.completion",
}

safely_load_modules(utility_modules, not is_startup)

----------------------
-- Writing Setup ✍️  --
------------------- --

local writing_modules = {
    "le.wiki-vim",
    "le.vim-markdown",
    {
        "le.atlas",
        function(atlas)
            atlas.setup()
        end,
    },
}

safely_load_modules(writing_modules, not is_startup)

-- For REPL or Debug Purposes
_G.cfg_env = lf.get_locals()
