local helpers = {}

--- Retrieve Current Time
local get_time = function(format)
    local format_table = {
        weekday_short = "%a",
        weekday = "%A",
        month_name_short = "%b",
        month_name = "%B",
        day = "%d",
        hour_12 = "%I",
        hour = "%H",
        minute = "%M",
        am_pm = "%p",
        month = "%m",
        second = "%S",
        weekday_num = "%w",
        date = "%x",
        time = "%X",
        year = "%Y",
        year_short = "%y",
    }

    if format ~= nil and format ~= "" then
        if format == "HELP" then
            return format_table
        end
        return os.date(format)
    end
    return {
        hour = tonumber(os.date("%H")),
        minute = tonumber(os.date("%M")),
        second = tonumber(os.date("%S")),
        my_date = os.date("%Y-%m-%dT%H:%M:%S"),
        format = os.date,
    }
end
helpers.get_time = get_time

return helpers
