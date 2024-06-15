local config = function()
    local which_key = require("which-key")
    return which_key.setup({
        window = { position = "bottom", winblend = 7 },
        layout = { align = "center", width = { max = 80 } },
    })
end

local lazy_spec = {
    { "folke/which-key.nvim", config = config, priority = 1000, lazy = false },
}

return lazy_spec
