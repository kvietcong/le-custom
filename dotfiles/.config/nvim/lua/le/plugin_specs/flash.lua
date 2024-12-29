local config = function()
    local flash = require("flash")
    flash.setup({
        modes = {
            search = { enabled = false },
            char = {
                char_actions = function()
                    return { [";"] = "next", [","] = "prev" }
                end,
            },
        },
    })
    vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash mode" })
    vim.keymap.set(
        { "x", "o" },
        "S",
        flash.treesitter,
        { desc = "Flash mode (Treesitter)" }
    )
end

local lazy_spec = { { "folke/flash.nvim", config = config } }

return lazy_spec
