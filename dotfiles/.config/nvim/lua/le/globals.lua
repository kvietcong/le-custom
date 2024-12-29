_G.le_group = vim.api.nvim_create_augroup("LeConfiguration", { clear = true })
_G.is_neovide = vim.g.neovide ~= nil
_G.is_nvui = vim.g.nvui ~= nil
_G.is_fvim = vim.g.fvim_loaded
_G.is_goneovim = vim.g.goneovim
_G.is_gui = is_neovide or is_nvui or is_fvim or is_goneovim
_G.is_mac = vim.fn.has("mac") == 1
_G.is_wsl = vim.fn.has("wsl") == 1
_G.is_win = vim.fn.has("win32") == 1
_G.is_unix = vim.fn.has("unix") == 1
_G.is_linux = vim.fn.has("linux") == 1
_G.data_path = vim.fn.stdpath("data"):gsub("\\", "/")
_G.config_path = vim.fn.stdpath("config"):gsub("\\", "/")
_G.lsp_servers = {
    "lua_ls",
    "rust_analyzer",
    "lua_ls",
    "pyright",
    "ts_ls",
    "cssls",
    "html",
    "emmet_ls",
    -- "hls",
    "bashls",
    "yamlls",
    "wgsl_analyzer",
    "vimls",
}

-- Globally helpful things
_G.P = function(...)
    vim.print(...)
end
_G.PR = function(...)
    P(...)
    return ...
end

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
