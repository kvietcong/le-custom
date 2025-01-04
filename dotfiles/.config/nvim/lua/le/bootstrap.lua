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

local missing_executables = {}
for _, exe in pairs(required_executables) do
    if vim.fn.executable(exe) == 0 then
        table.insert(missing_executables, exe)
    end
end
if #missing_executables > 0 then
    vim.fn.timer_start(5000, function()
        require("le.lib").notify_error(
            "MISSING EXECUTABLES: " .. table.concat(missing_executables, ", ")
        )
    end)
end

-- Bootstrap lazy.nvim
local plugins_path = data_path .. "/lazy"
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
