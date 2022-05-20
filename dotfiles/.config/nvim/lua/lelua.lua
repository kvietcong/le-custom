---------------------------
-- Le Lua Module (lelua) --
---------------------------

-- The Fennel Took Over XD
-- I will add some duplicated efforts here just to have both implementations for reference.

-- Dependencies
local Job = require("plenary.job")

-- Module to return
local M = {
    le_atlas = {}
}

local notify_level = function(message, level, custom_title)
    vim.notify(message, level, {
        title = custom_title or level:gsub("^%l", string.upper) })
end

for level, _ in pairs(vim.log.levels) do
    level = string.lower(level)
    M["notify_" .. level] = function(message)
        notify_level(message, level)
    end
end

M.set_register_and_notify = function(item, message, title)
    if type(message) == "function" then message = message(item) end
    message = message or ('"' .. item .. '" Ready to Paste!')
    vfn.setreg("", item)
    M.notify_info(message, title or "Register Set")
end

--- Retrieve Current Time
-- A note for weary travelers like me. os.date uses C's
-- strftime under the hood. Vim's builtin strftime does too.
-- Now most websites don't have all the format specifiers
-- so it's best to go to the man pages of C's strftime
-- directly. It took me quite a while to discover this
-- and I finally found %V was what I was looking for.
M.get_date = function(format)
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

M.quotify = function(...)
    local item = ""
    for _, term in ipairs({...}) do
        item = item .. term
    end
    return '"' .. item .. '"'
end

M.get_is_falsy = function(item)
    return not item or item == "" or item == {}
end

M.get_not_is_falsy = function(item) return not M.get_is_falsy(item) end

M.fd_async = function(args, callback, options)
    options = options or {}
    callback = callback or identity

    if options.cwd then
        if is_win then
            -- WHY YOU SO WACK WINDOWS
            options.cwd = options.cwd:gsub("~", "$HOME")
        end
        options.cwd = vfn.expand(options.cwd, nil, nil)
    end

    local job_options = t.extend("keep", {
        command = "fd",
        args = args or {},
        on_exit = function(job, exit_code)
            local result = job:result()
            callback(result, job, exit_code)
        end
    }, options)

    local job = Job:new(job_options)
    job:start()

    return job
end

-----------------------
-- Le Atlas Stuff 🗺️ --
-----------------------

M.le_atlas.add_save_hook = function(le_group)
    vapi.nvim_create_autocmd({"BufWritePre"}, {
        group = le_group,
        desc = "Clean up and update metadata when taking notes.",
        pattern = { "*.md", "*.mdx", "*.txt", "*.wiki" },
        callback = function(_ --[[eventInfo]])
            local is_modified = vapi.nvim_buf_get_option(0, "modified")
            if is_modified then
                vapi.nvim_command([[%s/edited: \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d/edited: ]] .. lefen.get_date().my_date .. "/ge")
            end
            vapi.nvim_command([[%s/\(^.\+\n\)\(^#\+ .*\n\)/\1\r\2/gec]]) -- It took a lot of trial and error for this XD
        end
    })
end

M.le_atlas.get_wikilink_info_under_cursor = function()
    -- I use register `z` to avoid conflict
    local cursor_before_yank = vapi.nvim_win_get_cursor(0)
    local register_old_value = vfn.getreg("z", nil, nil)

    vim.cmd[[normal vi["zy]]
    local cursor_after_yank = vapi.nvim_win_get_cursor(0)
    if cursor_after_yank[1] ~= cursor_before_yank[1] then
        return nil
    end

    local wikilink = vfn.getreg("z", nil, nil):gsub("[%[%]]", "")
    local wikilink_info = vfn.split(wikilink, "|", true)
    if #wikilink_info == 1 then
        t.insert(wikilink_info, wikilink_info[1])
    elseif #wikilink_info > 2 then
        M.notify_error("Invalid Link Under The Cursor")
        return
    end
    wikilink_info.alias = wikilink_info[2]
    wikilink_info.filename = wikilink_info[1]

    vfn.setreg("z", register_old_value)
    vapi.nvim_win_set_cursor(0, cursor_before_yank)

    return wikilink_info
end

-- I've decided that things with an async suffix will take
-- callbacks return a started job
M.le_atlas.wiki_filename_to_filepath_async = function(filename, callback)
    return M.fd_async({"-g", filename .. ".md" }, callback, { cwd = vim.g.wiki_root })
end

-- THIS IS BLOCKING
M.le_atlas.wiki_filename_to_filepath = function(filename)
    local possible_filepaths
    M.le_atlas.wiki_filename_to_filepath_async(filename, function(data)
        possible_filepaths = data
    end):sync()
    return possible_filepaths
end

M.le_atlas.get_possible_links_async = function(callback)
    return M.fd_async({ "-g", "*.md" }, callback, { cwd = vim.g.wiki_root })
end

M.le_atlas.get_possible_links = function()
    local possible_links
    M.le_atlas.get_possible_links_async(function(possible_filepaths)
        possible_links = possible_filepaths
    end):sync()
    return possible_links
end

M.le_atlas.get_link = function(callback)
    local possible_links = M.le_atlas.get_possible_links()
    local get_filename = function(filepath)
        return vfn.fnamemodify(filepath, ":t:r")
    end
    vim.ui.select(
        possible_links,
        {
            prompt = "Select a Note",
            format_item = get_filename,
        },
        function(selection)
            local filename = get_filename(selection)
            vim.ui.input({
                prompt = "Alias (Nothing for No Alias)",
            }, function(alias)
                local link = filename
                if M.get_not_is_falsy(alias) then
                    link = link .. "|" .. alias
                end
                callback("[[" .. link .. "]]")
            end)
        end
    )
end

M.le_atlas.get_link_and_copy = function()
    M.le_atlas.get_link(M.set_register_and_notify)
end

M.le_atlas.get_link_and_insert = function()
    M.le_atlas.get_link(function(link)
        local cursor = vapi.nvim_win_get_cursor(0)
        local column = cursor[2]
        local line = vapi.nvim_get_current_line()
        local new_line = line:sub(1, column + 1) .. link .. line:sub(column + 2)
        vapi.nvim_set_current_line(new_line)
        vapi.nvim_win_set_cursor(0, { cursor[1], column + #link })
        vapi.nvim_feedkeys("a", "m", nil)
    end)
end

M.le_atlas.open_wikilink_under_cursor = function(will_split, is_sync)
    local wikilink_info = M.le_atlas.get_wikilink_info_under_cursor()
    if not wikilink_info then
        vim.notify("No Link Under Your Cursor", "error", {title = "Error"})
        return
    end
    local filename = wikilink_info.filename

    if not is_sync then
        M.le_atlas.wiki_filename_to_filepath_async(filename, function(filepaths)
            local file = filepaths[1]
            if not file then
                vim.notify("Could not find file", "error", {title = "Error"})
                return
            end
            P(file)
            vim.schedule_wrap(function()
                if will_split then
                    vim.cmd(":vsplit " .. file)
                else
                    vim.cmd(":e " .. file)
                end
            end)()
        end)
    else
        local filepaths = M.le_atlas.wiki_filename_to_filepath(filename)
        local file = filepaths[1]
        if not file then
            vim.notify("Could not find file", "error", {title = "Error"})
            return
        end
        if will_split then
            vim.cmd(":vsplit " .. file)
        else
            vim.cmd(":e " .. file)
        end
    end
end

return M
