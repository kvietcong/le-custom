local M = {}

---@param tbl table Table to search
---@param target_value any Value to search
---@return nil|string key Table key of the value
local get_key_from_value = function(tbl, target_value)
    local found = nil
    for key, value in pairs(tbl) do
        if value == target_value then
            found = key
            break
        end
    end
    return found
end

---@param message string
---@param level number Level of notification to use (see `vim.log.levels`)
---@param custom_title string
local notify_level = function(message, level, custom_title)
    local title = custom_title
    if custom_title == nil then
        title = get_key_from_value(vim.log.levels, level):gsub("^%l", string.upper)
    end
    vim.notify(message, level, {
        title = title,
    })
end

for level, level_number in pairs(vim.log.levels) do
    local notifier = function(message, custom_title)
        notify_level(message, level_number, custom_title)
    end
    M["notify_" .. level] = notifier
    M["notify_" .. level:lower()] = notifier
end

---@param x any
---@return boolean is_falsy
M.get_is_falsy = function(x)
    return (not x) or (x == "") or (x == 0) or (x == vim.NIL)
end

---Replaces vim termcodes like <Enter> w/ proper mapping value
---See vim.api.nvim_replace_termcodes
---@param rhs string Action String (Right Hand Side)
---@return string rhs Action string w/ correct termcode values
M.clean = function(rhs)
    return vim.api.nvim_replace_termcodes(rhs, true, true, true)
end

---Return whether or not the file is large (many lines or literally large)
---@param buf_number number Buffer ID
---@return boolean is_thicc
M.get_is_thicc_buffer = function(buf_number)
    buf_number = buf_number or 0
    local buf_name = vim.api.nvim_buf_get_name(buf_number)
    local buf_size = vim.fn.getfsize(buf_name)
    local line_amount = vim.api.nvim_buf_line_count(buf_number)
    return buf_size > (100 * 1024) or line_amount > 10000
end

---@return string text What's selected in visual mode
M.get_visual_selection = function()
    local a_orig = vim.fn.getreg("a")
    local mode = vim.fn.mode()
    if mode ~= "v" and mode ~= "V" then
        vim.cmd([[normal! gv]])
    end
    vim.cmd([[silent! normal! "ay]])
    local text = vim.fn.getreg("a")
    vim.fn.setreg("a", a_orig)
    return text
end

---Get if buffer w/ buffer id is a file
---@param buf_id integer
---@return boolean
M.get_is_file_buffer = function(buf_id)
    -- Not sure if it's 100% accurate but is the best "simple" way
    return vim.tbl_contains({ "", nil }, vim.api.nvim_buf_get_option(buf_id, "buftype"))
end

---Remove buffers not in a window
M.close_inactive_buffers = function()
    local active_buffers = vim.fn.tabpagebuflist()
    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
        if
            M.get_is_file_buffer(buf_id)
            and not vim.tbl_contains(active_buffers, buf_id)
        then
            vim.api.nvim_buf_delete(buf_id, {})
        end
    end
end

-- @param text The input string to escape.
-- @return string The escaped string, safe to use as a literal part of a regex pattern.
M.regex_escape = function(text)
    return text:gsub("([%^%$%(%)%.%[%]%*%+%-%?%{%}%=%!%|%:%\\-])", "\\%1")
end

return M
