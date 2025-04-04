_G.LE_GROUP = vim.api.nvim_create_augroup("LeConfiguration", { clear = true })
_G.IS_NEOVIDE = vim.g.neovide ~= nil
_G.IS_NVUI = vim.g.nvui ~= nil
_G.IS_FVIM = vim.g.fvim_loaded
_G.IS_GONEOVIM = vim.g.goneovim
_G.IS_GUI = IS_NEOVIDE or IS_NVUI or IS_FVIM or IS_GONEOVIM
_G.IS_MAC = vim.fn.has("mac") == 1
_G.IS_WSL = vim.fn.has("wsl") == 1
_G.IS_WIN = vim.fn.has("win32") == 1
_G.IS_UNIX = vim.fn.has("unix") == 1
_G.IS_LINUX = vim.fn.has("linux") == 1
_G.IS_WSL = IS_LINUX and ((os.getenv("WSL_DISTRO_NAME") or "") ~= "" and true or false)
_G.DATA_PATH = tostring(vim.fn.stdpath("data")):gsub("\\", "/")
_G.CONFIG_PATH = tostring(vim.fn.stdpath("config")):gsub("\\", "/")
_G.PRIORITY = {
    HIGH = 1000,
    MEDIUM = 500,
    DEFAULT = 50,
    LOW = 0,
}

local lsp_servers_by_executable = {
    node = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "cssls",
        "html",
        "emmet_ls",
        "bashls",
        "yamlls",
        "wgsl_analyzer",
        "vimls",
    },
    cargo = { "rust_analyzer" },
    go = { "gopls" },
    ghcup = { "hls" },
}

_G.LSP_SERVERS = vim.iter(lsp_servers_by_executable)
    :fold({}, function(acc, exe, lsp_servers)
        if vim.fn.executable(exe) == 0 then
            vim.fn.timer_start(1000, function()
                -- Delaying to get the cool notifications XD
                require("le.lib").notify_error(
                    string.format(
                        "Missing '%s' required for: %s",
                        exe,
                        vim.inspect(lsp_servers)
                    )
                )
            end)
            return acc
        end
        for _, lsp_server in ipairs(lsp_servers) do
            table.insert(acc, lsp_server)
        end
        return acc
    end)

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
