local reload = function()
    local plugin_list = require("lazy").plugins()
    local plugin_names = vim.tbl_map(function(plugin)
        return plugin.name
    end, plugin_list)
    vim.ui.select(plugin_names, {}, function(plugin_name)
        require("lazy").reload({ plugins = { plugin_name } })
    end)
end

local config = function()
    local wk = require("which-key")
    wk.setup({
        win = {
            width = { min = 30, max = 64 },
            height = { min = 4, max = 0.75 },
            padding = { 0, 1 },
            col = math.huge,
            row = 0,
            border = "solid",
            title = true,
            wo = { winblend = 10 },
        },
    })
    vim.fn.timer_start(1000, function()
        -- Tokyo Night is asynchronously setting highlight groups afterwards
        -- so I am doing this to make sure these are set afterwards
        require("le.lib").notify_info("Loaded WhichKey Highlights")
        vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Cursorline" })
        vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "Cursorline" })
        vim.api.nvim_set_hl(0, "WhichKeyTitle", { link = "Cursorline" })
    end)

    -- Misc mappings and Label Mappings made in init.vim
    wk.add({
        { "<Leader>w", "<C-w>", desc = "windows", proxy = "<C-w>" },
        { "<Leader><Leader>r", reload, desc = "reload plugin" },
        { "<Leader><Leader>q", desc = "quit all" },
        {
            group = "sessions",
            { "<Leader>s" },
            { "<Leader>sa", desc = "add to dictionary" },
            { "<Leader>sr", desc = "remove from dictionary" },
            { "<Leader>su", desc = "undo dictionary action" },
            { "<Leader>sl", desc = "next spelling error" },
            { "<Leader>sh", desc = "prev spelling error" },
        },
    })
end

local lazy_spec = {
    { "folke/which-key.nvim", config = config, priority = 1000, lazy = false },
}

return lazy_spec
