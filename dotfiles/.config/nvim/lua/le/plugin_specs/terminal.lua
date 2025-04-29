local kill_all_terminals = function()
    local i = 0
    while true do
        local output = vim.api.nvim_cmd({ cmd = "FloatermKill" }, { output = true })
        if output:match("No floaterms with the bufnr or name") then
            break
        end
        i = i + 1
    end
    local ending = i == 1 and "" or "s"
    if i > 0 then
        require("le.lib").notify_info("Killed " .. tostring(i) .. " terminal" .. ending)
    end
end

local toggle_term_type = function()
    if vim.g.floaterm_wintype == "split" then
        vim.g.floaterm_wintype = "float"
        vim.g.floaterm_height = 0.9
    else
        vim.g.floaterm_wintype = "split"
        vim.g.floaterm_height = 0.4
    end
    kill_all_terminals()
    require("le.lib").notify_info(
        "Switched to " .. vim.g.floaterm_wintype .. " terminals"
    )
end

local config = function()
    local wk = require("which-key")
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.autoclose = 1

    local term = function(cmd_list)
        local result = [[<C-\><C-n>]]
        if cmd_list == nil then
            return result
        end
        if type(cmd_list) == "string" then
            cmd_list = { cmd_list }
        end
        for _, cmd in ipairs(cmd_list) do
            result = result .. ":" .. cmd .. "<Enter>"
        end
        return result
    end

    wk.add({
        { "<C-t>", ":FloatermToggle<Enter>", desc = "open terminal" },
        { "<C-q>", toggle_term_type, desc = "toggle term type" },
    })
    wk.add({
        mode = "t",
        {
            "<C-t>",
            term("FloatermToggle"),
            desc = "close terminal",
        },
        { "<A-l>", term("FloatermNext"), desc = "Next Terminal" },
        {
            "<A-h>",
            term("FloatermPrev"),
            desc = "previous terminal",
        },
        {
            "<A-q>",
            term({ "FloatermKill", "FloatermToggle" }),
            desc = "quit/kill the current terminal",
        },
        {
            "<A-Q>",
            term("FloatermKill"),
            desc = "quit/kill the current terminal",
        },
        {
            "<A-n>",
            term("FloatermNew"),
            desc = "create new terminal",
        },
    })
    wk.add({
        mode = "v",
        {
            "<C-t>",
            ":FloatermSend<Enter>:FloatermShow<Enter>",
            desc = "send lines to terminal",
        },
    })
end

local lazy_spec = { { "voldikss/vim-floaterm", config = config } }

return lazy_spec
