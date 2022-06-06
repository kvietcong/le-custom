-- Session Management
local mini_sessions = require("mini.sessions")
local whichkey = require("le.which-key")
local lf = require("le.libf") -- My Helper module (Fennel)
-- local ll = require("le.libl") -- My Helper module (Lua)

-- Close buffers that don't restore from a session
local close_bad_buffers = function()
    vim.cmd([[ZenMode]])
    require("zen-mode").close()
    vim.notify.dismiss({ silent = true, pending = true })
    local buffer_numbers = vapi.nvim_list_bufs()
    for _, buffer_number in pairs(buffer_numbers) do
        -- local buffer_name = vapi.nvim_buf_get_name(buffer_number)
        local buffer_type = vapi.nvim_buf_get_option(buffer_number, "buftype")
        local is_modifiable = vapi.nvim_buf_get_option(buffer_number, "modifiable")
        if buffer_type == "nofile" or not is_modifiable then
            vapi.nvim_buf_delete(buffer_number, { force = true })
        end
    end
end

local session_path = data_path .. "/session/"
if vfn.empty(vfn.glob(session_path, nil, nil)) > 0 then
    vim.cmd("!mkdir " .. session_path)
end

mini_sessions.setup({
    hooks = {
        pre = {
            read = close_bad_buffers,
            write = close_bad_buffers,
        },
        post = {
            read = function()
                lf.notify_info(
                    "Loaded Session: " .. vfn.fnamemodify(vim.v.this_session, ":t:r")
                )
            end,
            write = function()
                lf.notify_info(
                    "Saved Session: " .. vfn.fnamemodify(vim.v.this_session, ":t:r")
                )
            end,
            delete = function()
                -- TODO: Maybe help improve
                lf.notify_info("Deleted Selected Session")
            end,
        },
    },
    verbose = { read = false, write = false, delete = false },
})

vapi.nvim_create_autocmd("VimLeavePre", {
    group = le_group,
    desc = "Save current session for restoration.",
    callback = function()
        mini_sessions.write("Last Session.vim", {})
    end,
})

local session_save_wrapper = function(input)
    if not input or input == "" or input == "null" then
        if vim.v.this_session and vim.v.this_session ~= "" then
            mini_sessions.write(nil, {})
            return
        end
        lf.notify_error("Please Give Session Name")
    elseif not pcall(mini_sessions.write, input .. ".vim", {}) then
        lf.notify_error("Session Write Has Failed (For Unknown Reasons)")
    end
end

vapi.nvim_create_user_command("SessionSave", function(command)
    session_save_wrapper(command.args)
end, { nargs = "?" })

-- TODO: Clean this up
whichkey.register({
    ["<Leader>ss"] = {
        function()
            local current_session = ""
            if vim.v.this_session and vim.v.this_session ~= "" then
                current_session = vfn.fnamemodify(vim.v.this_session, ":t:r")
            end

            local new_session_option = "[<<<Make New Session>>>]"
            local detected_names = {}
            if current_session and current_session ~= "" then
                t.insert(detected_names, 1, current_session)
            end
            for detected, _ in pairs(mini_sessions.detected) do
                local name = vfn.fnamemodify(detected, ":t:r")
                if name ~= current_session then
                    t.insert(detected_names, name)
                end
            end
            t.insert(detected_names, new_session_option)

            vim.ui.select(detected_names, {
                prompt = "Select Session to Save To (Current: " .. current_session .. ")",
            }, function(selection)
                if selection == new_session_option then
                    vim.ui.input({ prompt = "Session Name to Save:" }, function(input)
                        session_save_wrapper(vfn.trim(input))
                    end)
                elseif selection then
                    session_save_wrapper(selection)
                end
            end)
        end,
        "(s)ession (s)ave <Session Name>",
    },
    ["<Leader>sS"] = { ":SessionSave<Enter>", "(s)ession (S)ave" },
    -- TODO: Reverse Save and selection order maybe?
    ["<Leader>sl"] = {
        function()
            local current_session = nil
            if vim.v.this_session and vim.v.this_session ~= "" then
                current_session = vfn.fnamemodify(vim.v.this_session, ":t:r")
            end
            if current_session then
                    print("HI")
                vim.ui.select({ "Yes Save", "No Just Leave" }, {
                    prompt = 'Save Session "' .. current_session .. '" Before Leaving?',
                }, function(_, index_selection)
                    if index_selection == 1 then
                        mini_sessions.write(nil)
                    end
                    mini_sessions.select("read", { force = true })
                end)
            else
                mini_sessions.select("read", { force = true })
            end
        end,
        "(s)ession (l)oad <Session Name>",
    },
    ["<Leader>sL"] = {
        function()
            mini_sessions.read(nil, {})
        end,
        "current (s)ession re(L)oad",
    },
    ["<Leader>sd"] = {
        function()
            mini_sessions.select("delete", { force = true })
        end,
        "(s)ession (d)elete",
    },
    ["<Leader>sn"] = {
        function()
            local message = "You are currently not in a session"
            local current_session = vim.v.this_session
            if not lf.get_is_falsy(current_session) then
                local session_name = vfn.fnamemodify(current_session, ":t:r")
                message = "You are currently in session `"
                    .. session_name
                    .. "` ("
                    .. current_session
                    .. ")"
            end
            print(message)
            lf.notify_info(message)
        end,
        "current (s)ession (n)otify",
    },
    ["<Leader>sq"] = {
        function()
            vapi.nvim_set_vvar("this_session", "")
            lf.notify_info("You have left the session")
        end,
        "(s)ession (q)uit",
    },
}, { silent = false })

return mini_sessions
