local config = function()
    local hydra = require("hydra")
    local keymap_util = require("hydra.keymap-util")
    local c = keymap_util.cmd
    local pc = keymap_util.pcmd
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
    hydra({
        name = "Window Manipulation",
        hint = [[

  ^^            🪟 Window Manipulation 🪟

  ^^              👆 _k_        ^^  Split Vertically    _v_
  [Resize] 👈 _h_ 🟰 _=_ 👉 _l_     Split Horizontally  _s_
  ^^              👇 _j_        ^^
  ^^                ^ ^         ^^  Select Other Window _w_
  ^^              👆 _K_        ^^
  [Move]   👈 _H_ ✨ _m_ 👉 _L_     Close Other Windows _o_
  ^^              👇 _J_        ^^  Close This Window  _c_/_q_  ^

                     ❌ _<Esc>_ ❌
        ]],
        body = "<Leader>wm",
        mode = "n",
        config = {
            invoke_on_body = true,
            hint = {
                float_opts = { border = "shadow" },
                type = "window",
                position = "middle",
            },
        },
        heads = {
            { "H", c("WinShift left") },
            { "J", c("WinShift down") },
            { "K", c("WinShift up") },
            { "L", c("WinShift right") },
            {
                "m",
                c("WinShift"),
                { exit = true },
            },
            { "h", resize_wrapper("left") },
            { "j", resize_wrapper("down") },
            { "k", resize_wrapper("up") },
            { "l", resize_wrapper("right") },
            { "=", "<C-w>=" },
            { "s", pc("split", "E36") },
            {
                "w",
                function()
                    vim.fn.win_gotoid(winshift_lib.pick_window())
                end,
            },
            { "v", pc("vsplit", "E36") },
            {
                "o",
                "<C-w>o",
                { exit = true, desc = "close other splits" },
            },
            { "c", pc("close", "E444") },
            { "q", pc("close", "E444"), { desc = "close window" } },
            { "<Esc>", nil, { exit = true } },
        },
    })
    hydra({
        name = "Vim Options",
        hint = [[

^^^^^^             🔧 Vim Options 🔧

^^^^^^  _w_: %{wrap} wrap
^^^^^^  _n_: %{nu} number
^^^^^^  _s_: %{spell} spell
^^^^^^  _c_: %{cul} cursor line
^^^^^^  _v_: %{ve} virtual edit
^^^^^^  _r_: %{rnu} relative number
^^^^^^  _l_: %{list} list (show invisible characters)  ^

^^^^^^                ❌ _<Esc>_ ❌
        ]],
        body = "<Leader>o",
        mode = { "n", "x" },
        config = {
            invoke_on_body = true,
            hint = { float_opts = { border = "shadow" }, position = "middle" },
        },
        heads = {
            {
                "n",
                function()
                    vim.o.number = not vim.o.number
                end,
            },
            {
                "r",
                function()
                    if vim.o.relativenumber then
                        vim.o.relativenumber = false
                    else
                        vim.o.number = true
                        vim.o.relativenumber = true
                    end
                end,
            },
            {
                "v",
                function()
                    if vim.o.virtualedit == "all" then
                        vim.o.virtualedit = "block"
                        return nil
                    else
                        vim.o.virtualedit = "all"
                        return nil
                    end
                end,
            },
            {
                "l",
                function()
                    vim.o.list = not vim.o.list
                    return nil
                end,
            },
            {
                "s",
                function()
                    vim.o.spell = not vim.o.spell
                    return nil
                end,
            },
            {
                "w",
                function()
                    vim.o.wrap = not vim.o.wrap
                    return nil
                end,
            },
            {
                "c",
                function()
                    vim.o.cursorline = not vim.o.cursorline
                    return nil
                end,
            },
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
end

local lazy_spec = {
    {
        "nvimtools/hydra.nvim",
        config = config,
        dependencies = { "sindrets/winshift.nvim", "mrjones2014/smart-splits.nvim" },
    },
}

return lazy_spec
