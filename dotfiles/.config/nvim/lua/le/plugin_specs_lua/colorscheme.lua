local update_colorscheme = function(bg_override)
    local lf = require("le.libf")
    local is_day
    local bg = bg_override or (is_day and "light" or "dark")
    if bg ~= vim.opt.background:get() then
        lf.notify_info("Updating color scheme to be " .. bg)
    end
    vim.cmd("set background=" .. bg)
    -- Prevent virtual text from blending in
    vapi.nvim_command("highlight NonText guifg=#6C768A")
end

local config = function()
    local catppuccin = require("catppuccin")
    catppuccin.setup({ background = { dark = "frappe", light = "latte" } })
    vim.cmd.colorscheme("catppuccin")
    _G.ColorschemeTimer = vfn.timer_start(
        100 * 60 * 15,
        function() return update_colorscheme() end,
        { ["repeat"] = -1 }
    )
    update_colorscheme()
end

local lazy_spec = {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = config,
        lazy = false,
        priority = 999,
    },
}

return lazy_spec
