-------------------------------------
--=================================--
--== Welcome to Le Neovim Config ==--
--=================================--
-------------------------------------

--[[ TODO List
- Contemplate moving to pure Lua b/c Lazy.nvim support for Fennel is sub-par
    - Also simpler in general. I would really miss working w/ Fennel tho
- Convert which-key.register calls to vim.keymap.set calls
- See if I can bring most of my Obsidian Workflow into Vim
- Learn how tabs work in Vim
- Check if every required executable is installed w/ vfn.executable
- Report issue that PDF makes telescope crash
- Move to LuaDate for all date stuff
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

function String.__index.trim(self)
    return self:gsub("^%s*(.-)%s*$", "%1")
end

function String.__index.urlencode(self)
    local char_to_hex = function(c)
        return string.format("%%%02X", string.byte(c))
    end
    local url = self:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

function String.__index.urldecode(self)
    local hex_to_char = function(x)
        return string.char(tonumber(x, 16))
    end
    local url = self:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end

-- Globally helpful things
_G.P = function(...)
    vim.print(...)
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
_G.is_gui = is_neovide or is_nvui or is_fvim or is_goneovim
_G.is_mac = vfn.has("mac") == 1
_G.is_wsl = vfn.has("wsl") == 1
_G.is_win = vfn.has("win32") == 1
-- local is_unix = fn.has("unix") == 1
-- local is_linux = fn.has("linux") == 1
_G.is_dev_mode = false
_G.data_path = vfn.stdpath("data"):gsub("\\", "/")
_G.config_path = vfn.stdpath("config"):gsub("\\", "/")

-- This is for sourcing on configuration change
vapi.nvim_create_autocmd({ "BufWritePost" }, {
    group = le_group,
    pattern = { "init.vim", "*/nvim/lua/*.lua", "*/nvim/fnl/*.fnl" },
    desc = "Auto re-source configuration files.",
    callback = function()
        if is_dev_mode then
            vim.cmd("source $MYVIMRC")
            vim.notify("Configuration Reloaded", nil, { title = "Info" })
        end
    end,
})

_G.lsp_servers = {
    "lua_ls",
    "rust_analyzer",
    "lua_ls",
    "pyright",
    "tsserver",
    "cssls",
    "html",
    "emmet_ls",
    "hls",
    "bashls",
    "yamlls",
    "wgsl_analyzer",
    "vimls",
    "fennel_language_server",
}
_G["lsp-servers"] = _G.lsp_servers

require("le.bootstrap")

-- This is to regen fnl plugin spec cache. I should really move off either hotpot or lazy
-- The likely issue is that lazy caches it and can't detect fnl/hotpot changes
for _, file in
    ipairs(
        vim.fn.readdir(
            vim.fn.stdpath("config") .. "/fnl/le/plugin_specs",
            [[v:val =~ '\.fnl$']]
        )
    )
do
    require("le.plugin_specs." .. file:gsub("%.fnl$", ""))
end

require("lazy").setup(
    -- Bug w/ Lazy or Hotpot: It doesn't support same name for lua and fnl folders for imports :(
    { { import = "le.plugin_specs_lua" }, { import = "le.plugin_specs" } },
    {}
)

local plenary = require("plenary")

-- Force reload specific modules for faster development
if not is_startup then
    plenary.reload.reload_module("le.libf")
end

-- Load Helper Module
local lf = require("le.libf") -- My Helper module (Fennel)

-- Escaped Strings are Pain in Fennel
_G.DashboardArt = [[
__      __          _                                              _  __  __   __
\ \    / / ___     | |     __      ___    _ __     ___      o O O | |/ /  \ \ / /
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o      | ' <    \ V /
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O] |_|\_\   _\_/_
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======|_|"""""|_| """"|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-'
]]

local safely_load_module = function(module_name, will_lazy_load)
    local callback
    if lf.get_is_list(module_name) then
        callback = module_name[2]
        module_name = module_name[1]
    end
    if not will_lazy_load then
        plenary.reload.reload_module(module_name)
    end
    local is_loading_ok, return_value = pcall(require, module_name)
    if not is_loading_ok then
        lf.notify_error("Failed to load module: " .. module_name)
        lf.notify_error(return_value)
    else
        if callback then
            callback(return_value)
        end
    end
end

local safely_load_modules = function(modules, will_lazy_load)
    for _, module in pairs(modules) do
        safely_load_module(module, will_lazy_load)
    end
end

-------------------------
-- Make Neovim Pretty! --
-------------------------

local pretty_modules = {
    "le.gui",
    "le.notify",
    "le.starter",
    "le.dressing",
    "le.colorizer",
    "le.status",
    "le.indentscope",
}

safely_load_modules(pretty_modules)

------------------------------
-- Useful Utilities Setup ⚙️ --
------------------------------

local utility_modules = {
    "le.misc",
    "le.fnl-init",
    "le.sessions",
    "le.surround",
    "le.cursorword",
    "le.trailspace",
}

safely_load_modules(utility_modules)

-- For REPL or Debug Purposes
_G.cfg_env = lf.get_locals()
