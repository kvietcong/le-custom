local plugins_path = data_path .. "/lazy"

-- Bootstrap lazy.nvim
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

-- Bootstrap hotpot.nvim
local hotpot_path = plugins_path .. "/hotpot.nvim"
if not (vim.uv or vim.loop).fs_stat(hotpot_path) then
    vim.notify("Bootstrapping hotpot.nvim...", vim.log.levels.INFO)
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/rktjmp/hotpot.nvim.git",
        hotpot_path,
    })
    vim.cmd("helptags " .. hotpot_path .. "/doc")
end
vim.opt.runtimepath:prepend(hotpot_path)

local hotpot = require("hotpot")
hotpot.setup({
    provide_require_fennel = true,
})
vapi.nvim_create_autocmd("BufEnter", {
    group = le_group,
    pattern = { "*.fnl" },
    desc = "Setup Fennel Specific Things",
    callback = function()
        vim.cmd("abbreviate <buffer> alam λ")
        vim.cmd("abbreviate <buffer> lambo λ")
    end,
})
