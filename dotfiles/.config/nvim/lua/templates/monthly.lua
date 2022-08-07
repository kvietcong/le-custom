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
created: <%- the_date:fmt("%Y-%m-%dT%H:%M:%S") %>
edited: <%- the_date:fmt("%Y-%m-%dT%H:%M:%S") %>
tags:
- Journal/Monthly
---

[[<%- last_month:fmt("%Y-%m") %>|⏮] | [[- My Journal -|📖]] | [[<%- next_month:fmt("%Y-%m") %>|⏭]]

# Review for <%- the_date:fmt("%B %Y") %>

#TODO

]==])

local get_monthly = function(the_date)
    the_date = the_date or date()
    return template({
        the_date = the_date,
        get_is_falsy = get_is_falsy,
        aliases = {the_date:fmt("%B %Y")},
        last_month = the_date:copy():addmonths(-1),
        next_month = the_date:copy():addmonths(1)
    })
end

print(get_monthly())

return get_monthly
