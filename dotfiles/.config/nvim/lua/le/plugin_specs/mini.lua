local dashboard_art = [[
__      __          _                                              _  __  __   __
\ \    / / ___     | |     __      ___    _ __     ___      o O O | |/ /  \ \ / /
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o      | ' <    \ V /
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O] |_|\_\   _\_/_
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======|_|"""""|_| """"|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-'
]]

local setup_sessions = function()
    local sessions = require("mini.sessions")
    local lib = require("le.lib")
    local wk = require("which-key")

    local session_path = data_path .. "/session/"
    if vim.fn.empty(vim.fn.glob(session_path, nil, nil)) > 0 then
        vim.cmd("!mkdir " .. session_path)
    end

    -- [TODO]: Determine how to restore terminal sessions on Windows (Powershell)
    sessions.setup({
        hooks = {
            pre = {
                write = function() end,
            },
            post = {
                read = function()
                    lib.notify_info(
                        "Loaded Session: "
                            .. vim.fn.fnamemodify(vim.v.this_session, ":t:r")
                    )
                end,
                write = function()
                    lib.notify_info(
                        "Saved Session: "
                            .. vim.fn.fnamemodify(vim.v.this_session, ":t:r")
                    )
                end,
                delete = function()
                    -- [TODO]: Maybe help improve
                    lib.notify_info("Deleted Selected Session")
                end,
            },
        },
        verbose = { read = false, write = false, delete = false },
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = le_group,
        desc = "Save current session for restoration.",
        callback = function()
            sessions.write("Last Session.vim", {})
        end,
    })

    local session_save_wrapper = function(input)
        if not input or input == "" or input == "null" then
            if vim.v.this_session and vim.v.this_session ~= "" then
                sessions.write(nil, {})
                return
            end
            lib.notify_error("Please Give Session Name")
        elseif not pcall(sessions.write, input .. ".vim", {}) then
            lib.notify_error("Session Write Has Failed (For Unknown Reasons)")
        end
    end

    vim.api.nvim_create_user_command("SessionSave", function(command)
        session_save_wrapper(command.args)
    end, { nargs = "?" })

    local save_session = function()
        local current_session = ""
        if vim.v.this_session and vim.v.this_session ~= "" then
            current_session = vim.fn.fnamemodify(vim.v.this_session, ":t:r")
        end

        local detected_names = {}
        if current_session and current_session ~= "" then
            table.insert(detected_names, current_session)
        end
        for detected, _ in pairs(sessions.detected) do
            local name = vim.fn.fnamemodify(detected, ":t:r")
            if name ~= current_session then
                table.insert(detected_names, name)
            end
        end

        vim.ui.select(detected_names, {
            prompt = "Select Session to Save To (Current: " .. current_session .. ")",
        }, function(selection, i)
            if i == nil then
                vim.ui.input(
                    { prompt = "Session Name to Save (Empty to cancel)" },
                    function(input)
                        if not lib.get_is_falsy(input) then
                            input = vim.fn.trim(input)
                            lib.notify_info(input)
                            session_save_wrapper(input)
                        else
                            lib.notify_warn("Didn't save any session")
                        end
                    end
                )
            elseif selection then
                session_save_wrapper(selection)
            end
        end)
    end

    local load_session = function()
        if not lib.get_is_falsy(vim.v.this_session) then
            sessions.write()
        end
        sessions.select("read", { force = true })
    end

    local notify_current_session = function()
        local message = "You are currently not in a session"
        local current_session = vim.v.this_session
        if not lib.get_is_falsy(current_session) then
            local session_name = vim.fn.fnamemodify(current_session, ":t:r")
            message = "You are currently in session `"
                .. session_name
                .. "` ("
                .. current_session
                .. ")"
        end
        print(message)
        lib.notify_info(message)
    end

    local leave_current_session = function()
        vim.api.nvim_set_vvar("this_session", "")
        lib.notify_info("You have left the session")
    end

    wk.add({
        mode = { "n" },
        { "<Leader>s", group = "session" },
        {
            "<Leader>ss",
            save_session,
            desc = "(s)ession (s)ave <Session Name>",
        },
        {
            "<Leader>sS",
            ":SessionSave<Enter>",
            desc = "(s)ession (S)ave",
        },
        {
            "<Leader>sl",
            load_session,
            desc = "(s)ession (l)oad <Session Name>",
        },
        {
            "<Leader>sL",
            function()
                sessions.read(nil, {})
            end,
            desc = "current (s)ession re(L)oad",
        },
        {
            "<Leader>sd",
            function()
                sessions.select("delete", { force = true })
            end,
            desc = "(s)ession (d)elete",
        },
        {
            "<Leader>sn",
            notify_current_session,
            desc = "current (s)ession (n)otify",
        },
        {
            "<Leader>sq",
            leave_current_session,
            desc = "(s)ession (q)uit",
        },
    })
end

local setup_dashboard = function()
    local starter = require("mini.starter")
    starter.setup({
        header = dashboard_art,
        items = {
            starter.sections.sessions(16, true),
            starter.sections.recent_files(3),
            starter.sections.builtin_actions,
        },
    })
end

local setup_surround = function()
    local surround = require("mini.surround")
    surround.setup({
        custom_surroundings = {
            ["|"] = {
                output = { left = "|", right = "|" },
            },
            ["`"] = {
                output = { left = "`", right = "`" },
            },
        },
        mappings = {
            add = "ys",
            delete = "ds",
            find = ">S",
            find_left = "<S",
            highlight = "sh",
            replace = "cs",
            update_n_lines = "",
            suffix_last = "",
            suffix_next = "",
        },
        n_lines = 50,
    })
end

local os_symbols = { unix = "", dos = "", mac = "" }
local setup_statusline = function()
    local statusline = require("mini.statusline")
    local navic = require("nvim-navic")
    vim.o.laststatus = 3
    vim.o.winbar = "%#MiniStatuslineFilename#%=%f%="
    local get_statusline = function()
        local nav_string = nil
        if navic.is_available() and navic.get_location() then
            nav_string = navic.get_location()
        end

        local mode, mode_highlight = statusline.section_mode({
            trunc_width = 100000,
        })

        local filename = vim.fn.expand("%:~:.")
        local location = "%l:%v (%p%%)"

        return statusline.combine_groups({
            { strings = { mode }, hl = mode_highlight },
            {
                strings = { statusline.section_git({}) },
                hl = "Cursor",
            },
            {
                strings = { statusline.section_diagnostics({}) },
                hl = "MiniStatuslineFilename",
            },
            "%<",
            { strings = { nav_string }, hl = "MiniStatuslineDevinfo" },
            "%<",
            "%=",
            { strings = { filename }, hl = mode_highlight },
            {
                strings = {
                    statusline
                        .section_fileinfo({})
                        :gsub(vim.bo.fileformat, os_symbols[vim.bo.fileformat]),
                },
                hl = "MiniStatuslineFileinfo",
            },
            { strings = { location }, hl = mode_highlight },
        })
    end
    statusline.setup({
        set_vim_settings = false,
        content = { active = get_statusline },
    })
end

local setup_indentscope = function()
    local indentscope = require("mini.indentscope")
    indentscope.setup({
        symbol = "⟫",
    })

    vim.api.nvim_create_autocmd("TermOpen", {
        group = le_group,
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = le_group,
        callback = function(event)
            local lib = require("le.lib")
            if lib.get_is_thicc_buffer(event.buf) then
                vim.b.miniindentscope_disable = true
                lib.notify_warn("This buffer is quite large! Disabling indent scope")
            end
        end,
        vim.api.nvim_command("highlight Delimiter guifg=#4C566A"),
    })
end

local setup_trailspace = function()
    local trailspace = require("mini.trailspace")
    trailspace.setup({})
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = le_group,
        desc = "Trim trailing spaces on save",
        callback = trailspace.trim,
    })
end

local setup_highlights = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            hex_color = hipatterns.gen_highlighter.hex_color({}),
        },
    })
end

local setup_files = function()
    local files = require("mini.files")
    local wk = require("which-key")
    files.setup({ mappings = { go_in_plus = "<Enter>" } })
    local open_file_explorer = function()
        files.open(vim.api.nvim_buf_get_name(0))
    end
    wk.add({
        { "<C-f>", open_file_explorer, desc = "file explorer" },
        { "<Leader>fe", open_file_explorer, desc = "file explorer" },
    })
    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(event)
            wk.add({
                buffer = event.data.buf_id,
                { "<C-o>", files.go_out },
                { "<C-f>", files.close },
                { "<Leader>fe", files.close },
                { "<C-s>", files.synchronize },
                { "<localleader>s", files.synchronize },
                { "w", files.synchronize, mode = { "c" } },
            })
        end,
    })
end

local setup_buffers = function()
    local bufremove = require("mini.bufremove")
    bufremove.setup({})

    local tabline = require("mini.tabline")
    tabline.setup({
        tabpage_section = "right",
    })

    local wk = require("which-key")
    wk.add({
        { "<Leader>b", group = "buffers" },
        { "<Leader>bf", ":Telescope buffers<Enter>", desc = "find" },
        { "<M-l>", ":bn<Enter>", desc = "next" },
        { "<M-h>", ":bp<Enter>", desc = "prev" },
        { "<M-Right>", ":bn<Enter>", desc = "next" },
        { "<M-Left>", ":bp<Enter>", desc = "prev" },
        { "<Leader>bo", ":BO<Enter>", desc = "only this" },
        {
            "<Leader>bq",
            function()
                bufremove.unshow_in_window()
            end,
            desc = "quit (unshow)",
        },
        {
            "<Leader>bd",
            function()
                bufremove.delete(0, true)
            end,
            desc = "delete",
        },
    })
end

local config = function()
    setup_dashboard()
    setup_sessions()
    setup_surround()
    setup_statusline()
    setup_buffers()
    setup_indentscope()
    setup_trailspace()
    setup_highlights()
    setup_files()
    require("mini.cursorword").setup({ delay = 500 })
    require("mini.move").setup({})
end

local lazy_spec = {
    {
        "echasnovski/mini.nvim",
        config = config,
        dependencies = {
            "folke/which-key.nvim",
            "SmiteshP/nvim-navic",
        },
    },
}

return lazy_spec
