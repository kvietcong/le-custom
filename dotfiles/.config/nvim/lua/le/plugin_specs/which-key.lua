local get_option_toggler = function(option)
    return function()
        vim.o[option] = not vim.o[option]
    end
end

local get_option_desc = function(option)
    return function()
        local option_value = vim.o[option]
        local option_type = type(option_value)
        if option_type == "string" then
            return option .. ': "' .. option_value .. '"'
        elseif option_type == "boolean" then
            return option .. ": " .. (option_value and "ON" or "OFF")
        end
        return option .. ": " .. vim.inspect(vim.o[option])
    end
end

local cycle_virtual_edit = function()
    if vim.o.virtualedit == "block" then
        vim.o.virtualedit = "insert"
    elseif vim.o.virtualedit == "insert" then
        vim.o.virtualedit = "all"
    elseif vim.o.virtualedit == "all" then
        vim.o.virtualedit = "onemore"
    elseif vim.o.virtualedit == "onemore" then
        vim.o.virtualedit = "none"
    elseif vim.o.virtualedit == "none" or vim.virtualedit == "" then
        vim.o.virtualedit = "block"
    else
        vim.o.virtualedit = "none"
    end
end

local setup_vim_options = function()
    local wk = require("which-key")
    wk.add({
        {
            "<Leader>o",
            group = "options",
        },
        {
            "<Leader>o<Leader>",
            function()
                wk.show({ keys = "<Leader>o", loop = true })
            end,
            desc = "Hydra Mode",
        },
        {
            "<Leader>on",
            get_option_toggler("number"),
            desc = get_option_desc("number"),
        },
        {
            "<Leader>or",
            function()
                if vim.o.relativenumber then
                    vim.o.relativenumber = false
                else
                    vim.o.number = true
                    vim.o.relativenumber = true
                end
            end,
            desc = get_option_desc("relativenumber"),
        },
        {
            "<Leader>ov",
            cycle_virtual_edit,
            desc = get_option_desc("virtualedit"),
        },
        {
            "<Leader>ol",
            get_option_toggler("list"),
            desc = get_option_desc("list"),
        },
        {
            "<Leader>os",
            get_option_toggler("spell"),
            desc = get_option_desc("spell"),
        },
        {
            "<Leader>ow",
            get_option_toggler("wrap"),
            desc = get_option_desc("wrap"),
        },
        {
            "<Leader>oc",
            get_option_toggler("cursorline"),
            desc = get_option_desc("cursorline"),
        },
    })
end

local setup_window_manipulation = function()
    local splits = require("smart-splits")
    local winshift = require("winshift")
    local winshift_lib = require("winshift.lib")
    splits.setup({})
    winshift.setup({})

    local resize_wrapper = function(direction)
        return function()
            return splits["resize_" .. direction](2)
        end
    end
    local c = function(cmd)
        return ":" .. cmd .. "<Enter>"
    end
    local wk = require("which-key")
    wk.add({
        { "<Leader>wm", group = "window manipulation" },
        {
            "<Leader>w<Leader>",
            function()
                wk.show({ keys = "<Leader>wm", loop = true })
            end,
            desc = "Hydra Mode",
        },
        {
            "<Leader>wmH",
            c("WinShift left"),
            desc = "move left",
        },
        {
            "<Leader>wmJ",
            c("WinShift down"),
            desc = "move down",
        },
        {
            "<Leader>wmK",
            c("WinShift up"),
            desc = "move up",
        },
        {
            "<Leader>wmL",
            c("WinShift right"),
            desc = "move right",
        },
        {
            "<Leader>wmm",
            c("WinShift"),
            desc = "winshift mode",
        },
        {
            "<Leader>wmh",
            resize_wrapper("left"),
            desc = "resize left",
        },
        {
            "<Leader>wmj",
            resize_wrapper("down"),
            desc = "resize down",
        },
        {
            "<Leader>wmk",
            resize_wrapper("up"),
            desc = "resize up",
        },
        {
            "<Leader>wml",
            resize_wrapper("right"),
            desc = "resize right",
        },
        {
            "<Leader>wme",
            "<C-w>=",
            desc = "resize equal",
        },
        {
            "<Leader>wmw",
            function()
                vim.fn.win_gotoid(winshift_lib.pick_window())
            end,
            desc = "pick window",
        },
        { "<Leader>wmo", "<C-w>o", desc = "close other splits" },
    })
end

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
        { "<Leader>w", "<C-w>", group = "windows", proxy = "<C-w>" },
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

    setup_vim_options()
    setup_window_manipulation()
end

local lazy_spec = {
    {
        "folke/which-key.nvim",
        config = config,
        priority = 1000,
        lazy = false,
        dependencies = { "sindrets/winshift.nvim", "mrjones2014/smart-splits.nvim" },
    },
}

return lazy_spec
