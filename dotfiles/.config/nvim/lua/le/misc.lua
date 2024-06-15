-------------------
-- Miscellaneous --
-------------------

local whichkey = require("which-key")
local lf = require("le.libf")

-- Create directory on write if it doesn't exist
vapi.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    group = le_group,
    callback = function()
        local filepath = vfn.expand("<afile>")
        if string.match(filepath, "oil") then
            return
        end
        local directory = vfn.fnamemodify(filepath, ":p:h")
        local doesDirectoryExist = vfn.isdirectory(directory)
        if doesDirectoryExist == 0 then
            vfn.mkdir(directory, "p")
        end
    end,
})

-- Trigger autoread manually every second
-- This is so Vim auto-updates files on external change
AutoReadTimer = vfn.timer_start(5000, function()
    vim.cmd([[silent! checktime]])
end, { ["repeat"] = -1 })

local get_visual_selection = function()
    local a_orig = vfn.getreg("a")
    local mode = vim.fn.mode()
    if mode ~= "v" and mode ~= "V" then
        vim.cmd([[normal! gv]])
    end
    vim.cmd([[silent! normal! "ay]])
    local text = vfn.getreg("a")
    vim.fn.setreg("a", a_orig)
    return text
end

vim.keymap.set("v", "<Leader>s", function()
    local link = "https://google.com/search?q="
        .. get_visual_selection():trim():urlencode()
    if is_win then
        os.execute("start " .. link)
    else
        os.execute("xdg-open " .. link)
    end
    vapi.nvim_feedkeys(require("le.libf").clean("<Escape>"), "n", true)
end, { desc = "Search in browser" })

local parinfer_filetypes = {
    "clojure",
    "scheme",
    "lisp",
    "racket",
    "hy",
    "fennel",
    "janet",
    "carp",
    "wast",
    "yuck",
    "dune",
}

local mini_comment = require("mini.comment")
mini_comment.setup({
    options = {
        custom_commentstring = function()
            local contextual_commentstring = require("ts_context_commentstring").calculate_commentstring()
            return contextual_commentstring or vim.bo.commentstring
        end,
    },
})

-- Misc Mappings
whichkey.register({
    s = {
        name = "(s)essions",
    },
    ["<Leader>s"] = {
        name = "(s)pelling",
        a = "Add to Dictionary",
        r = "Remove from Dictionary",
        u = "Undo Last Dictionary Action",
        l = "Go to Next Spelling Error",
        h = "Go to Previous Spelling Error",
    },
    w = { name = "(w)indowing (Also Ctrl-w)" },
    c = {
        ["-"] = "Comment Banner (--)",
        ["="] = "Comment Banner (==)",
        ["/"] = "Comment Banner (//)",
        f = { ":Format<Enter>", "(c)ode (f)ormatting" },
    },
    ["<Leader>"] = {
        q = "(q)uit all",
        r = {
            function()
                vim.cmd("source $MYVIMRC")
                lf.notify_info("Configuration Reloaded")
            end,
            "(r)e-source config",
        },
    },
}, { prefix = "<Leader>" })

vapi.nvim_create_autocmd("TextYankPost", {
    group = le_group,
    desc = "Highlight Yanked Text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
})

return true
