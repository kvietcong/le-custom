local config = function()
    local legendary = require("legendary")
    return legendary.setup({})
end

local lazy_spec = {
    { "mrjones2014/legendary.nvim", config = config, priority = 1000, lazy = false },
}

return lazy_spec
