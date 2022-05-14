local helpers = {}

-- Print Helper
P = function(...) vim.pretty_print(...) end

local set_register_and_notify = function(item, message, title)
    if type(message) == "function" then message = message(item) end
    message = message or ('"' .. item .. '" Ready to Paste!')
    vim.fn.setreg('"', item)
    vim.notify(message, "info", { title = title or "Register Set" })
end
helpers.set_register_and_notify = set_register_and_notify

--- Retrieve Current Time
-- A note for weary travelers like me. os.date uses C's
-- strftime under the hood. Vim's builtin strftime does too.
-- Now most websites don't have all the format specifiers
-- so it's best to go to the man pages of C's strftime
-- directly. It took me quite a while to discover this
-- and I finally found %V was what I was looking for.
local get_date = function(format)
    if format ~= nil and format ~= "" then
        return os.date(format)
    end
    return {
        year = tonumber(os.date("%Y")),
        month = tonumber(os.date("%m")),
        day = tonumber(os.date("%d")),
        hour = tonumber(os.date("%H")),
        minute = tonumber(os.date("%M")),
        second = tonumber(os.date("%S")),
        my_date = os.date("%Y-%m-%dT%H:%M:%S"),
        format = os.date,
    }
end
helpers.get_date = get_date

return helpers
