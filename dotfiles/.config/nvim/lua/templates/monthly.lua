local date = require("date")
local etlua = require("etlua")

local libf = require("le.libf")
local get_is_falsy = libf.get_is_falsy

local template = etlua.compile([==[
---
aliases:<% if get_is_falsy(aliases) then %> ~<% end %>
<% for _, alias in pairs(aliases) do -%>
- <%- alias %>
<% end -%>
created: <%- now:fmt("${le}") %>
edited: <%- now:fmt("${le}") %>
tags:
- Journal/Monthly
---

[[<%- last_month:fmt("%Y-%m") %>|⏮]] | [[- My Journal -|📖]] | [[<%- next_month:fmt("%Y-%m") %>|⏭]]

# Review for <%- the_date:fmt("%B %Y") %>
This is #TODO

]==])

local get_monthly = function(the_date)
    the_date = the_date or date()
    return template({
        now = date(),
        the_date = the_date,
        get_is_falsy = get_is_falsy,
        aliases = { the_date:fmt("%B %Y") },
        last_month = the_date:copy():addmonths(-1),
        next_month = the_date:copy():addmonths(1),
    })
end

return get_monthly
