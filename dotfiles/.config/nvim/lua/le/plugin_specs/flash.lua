local config = function()
    local flash = require("flash")
    flash.setup({
        modes = {
            search = { enabled = false },
        },
    })
    vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash mode" })
    return vim.keymap.set(
        { "x", "o" },
        "S",
        flash.treesitter,
        { desc = "Flash mode (Treesitter)" }
    )
end

local keys = { { "s" }, { "S" } }

local lazy_spec = { { "folke/flash.nvim", config = config, keys = keys } }

return lazy_spec
