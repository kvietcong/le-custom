-- Check for required executables
local required_executables = {
    "awk",
    "cargo",
    "fd",
    "git",
    "gzip",
    "npm",
    "rg",
    "stylua",
    "zig",
}

local missing_executables = vim.iter(required_executables):filter(function(required_executable)
    return vim.fn.executable(required_executable) == 0
end):totable()

if #missing_executables > 0 then
    vim.fn.timer_start(5000, function()
        require("le.lib").notify_error(
            "MISSING EXECUTABLES: " .. table.concat(missing_executables, ", ")
        )
    end)
end

-- Bootstrap lazy.nvim
local plugins_path = DATA_PATH .. "/lazy"
local lazy_path = plugins_path .. "/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazy_path,
    })
end

vim.opt.runtimepath:prepend(lazy_path)
