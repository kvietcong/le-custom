--- Split String on Delimiter
--- @param input string Given string to be split
--- @param delimeter string What to split by
--- @return string splitInput
local function split(input, delimiter)
    if delimiter == nil then delimiter = " " end
    local result = {}
    for token in string.gmatch(input, "([^"..delimiter.."]+)") do
        table.insert(result, token)
    end
    return result
end

--- Trim Trailing and Leading Whitespace
--- @param input string Given string to trim
--- @return string trimmedInput
local function trim(input)
  return (string.gsub(input, "^%s*(.-)%s*$", "%1"))
end

--- Keymap helper
--- @param map string Info about the map
--- @param options? string Extra options. Default options are `noremap` and `silent`
--- @param buff? string Buffer for local mappings
local function map(map, options, buff)
    if options == nil then
        options = { noremap = true, silent = true }
    else
        options = split(options)
        local new_options = {}
        for _, option in pairs(options) do
            new_options[option] = true
        end
        options = new_options
    end
    map = split(map)
    local function get_command(map)
        local command = ""
        for i, v in pairs(map) do
            if i > 2 then command = command .. " " .. v end
        end
        return trim(command)
    end
    if buff == nil then
        vim.api.nvim_set_keymap(map[1], map[2], get_command(map), options)
    else
        vim.api.nvim_buf_set_keymap(buff, map[1], map[2], get_command(map), options)
    end
end

--- Retrieve Current Time
--- @return table Table with Hour, Minute, and Formatted String
local function get_time()
    return {
        hour = tonumber(os.date("%H")),
        minute = tonumber(os.date("%M")),
        string = os.date("%H:%M")
    }
end

--- Retrieve Day Status
--- @return boolean
local function is_day()
    local hour = get_time().hour
    return hour > 6 and hour < 18
end

--- Safely Setup a Module (No Blocking)
--- @param string Name of the module (file name)
--- @return any Value Module's return value or error message
local function safe_setup(name)
    local success, result = pcall(require(name).setup)
    if not success then
        print(name.." setup failed")
        print("ERROR: "..result)
    end
    return result
end

return {
    safe_setup = safe_setup,
    get_time = get_time,
    is_day = is_day,
    split = split,
    trim = trim,
    map = map
}
