-- Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
    group = LE_GROUP,
    desc = "Highlight Yanked Text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
})

-- Create directory on write if it doesn't exist
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    group = LE_GROUP,
    callback = function()
        local filepath = vim.fn.expand("<afile>")
        if filepath:match("://") then
            return
        end
        local directory = vim.fn.fnamemodify(filepath, ":p:h")
        local doesDirectoryExist = vim.fn.isdirectory(directory)
        if doesDirectoryExist == 0 then
            vim.fn.mkdir(directory, "p")
        end
    end,
})

-- Trigger autoread manually every second
-- This is so Vim auto-updates files on external change
AutoReadTimer = vim.fn.timer_start(5000, function()
    vim.cmd([[silent! checktime]])
end, { ["repeat"] = -1 })

-- Web search selection
local lib = require("le.lib")
vim.keymap.set("v", "<Leader>s", function()
    local link = "https://google.com/search?q="
        .. lib.get_visual_selection():trim():gsub("\n", " "):urlencode()
    if IS_WIN then
        os.execute("start " .. link)
    else
        os.execute("xdg-open " .. link)
    end
    vim.api.nvim_feedkeys(lib.clean("<Escape>"), "n", true)
end, { desc = "Search in browser" })
