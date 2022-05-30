-------------------------------------
--=================================--
--== Welcome to Le Neovim Config ==--
--=================================--
-------------------------------------

--[[ TODO: General Configuration Things
- Find out why Windows emoji selector doesn't work with Neovide
- See if I can bring most of my Obsidian Workflow into Vim
- Check out :help ins-completion
- Check out Lua Snips
- Sort out nvim-cmp sources!
- Find a way to make it not lag on LARGE files (look at init.lua for telescope-emoji)
- See what I can do with Fennel configuration
- Learn how tabs work in Vim
- Play around with Conjure (WHICH IS SUPER COOL)
- Find out why I get a weird once in a while fold bug
- Check if every required executable is installed w/ vfn.executable
- Organize my config so that I can pcall everything
    - Also make it more modular because long files make it not as fast
]]

--------------------------
-- Setting Things Up 🔧 --
--------------------------

-- EMERGENCY
vim.api.nvim_set_keymap("n", "<F1>", "", {
    noremap = true,
    silent = true,
    desc = "EMERGENCY EDIT",
    callback = function()
        vim.cmd("e $MYVIMRC")
        vim.cmd("cd %:p:h")
        vim.cmd("e ./lua/le/libl.lua")
        vim.cmd("e ./fnl/le/libf.fnl")
        vim.cmd("e ./lua/init.lua")
    end,
})

-- Make built-in functions easier to access
_G.vfn = vim.fn
_G.vapi = vim.api
_G.P = function(...)
    vim.pretty_print(...)
end
_G.PR = function(...)
    P(...)
    return ...
end

-- Helpful Flags and Variables
_G.is_startup = vfn.has("vim_starting") == 1
_G.is_neovide = vim.g.neovide ~= nil
_G.is_nvui = vim.g.nvui ~= nil
_G.is_fvim = vim.g.fvim_loaded
_G.is_goneovim = vim.g.goneovim
_G.is_firenvim = vim.g.started_by_firenvim or false
_G.is_gui = is_neovide or is_nvui or is_fvim or is_goneovim or is_firenvim
_G.is_mac = vfn.has("mac") == 1
_G.is_wsl = vfn.has("wsl") == 1
_G.is_win = vfn.has("win32") == 1
-- local is_unix = fn.has("unix") == 1
-- local is_linux = fn.has("linux") == 1
_G.is_debugging = true
_G.data_path = vfn.stdpath("data"):gsub("\\", "/")
_G.config_path = vfn.stdpath("config"):gsub("\\", "/")
_G.is_going_hard = is_neovide

require("le.packer")

-- Load cached plugins for speed
require("impatient").enable_profile()

-- Load Fennel Integration
local hotpot = require("hotpot")
hotpot.setup({
    provide_require_fennel = true,
    compiler = {
        modules = {
            correlate = true,
        },
    },
})
vapi.nvim_create_autocmd({ "BufEnter" }, {
    group = le_group,
    desc = "Setup Fennel Specific things",
    pattern = { "*.fnl" },
    callback = function(
        _ --[[event]]
    )
        vim.cmd([[abbreviate <buffer> (;\ (λ]])
        vim.cmd([[abbreviate <buffer> ;\ λ]])
        vim.cmd([[abbreviate <buffer> lambda\ λ]])
        vim.cmd([[abbreviate <buffer> l\ λ]])
        vim.cmd([[abbreviate <buffer> (lambda\ (λ]])
        vim.cmd([[abbreviate <buffer> (l\ (λ]])
    end,
})
vapi.nvim_create_user_command("FnlCacheClear", function()
    local hotpot_cache = require("hotpot.api.cache")
    hotpot_cache["clear-cache"]()
end, {})

-- Which Key (Mapping reminders)
require("le.legendary")
local wk = require("le.which-key")

-- Ensure old timers are cleaned upon reloading
if not is_startup then
    vfn.timer_stopall()
end

-- Trigger autoread manually every second
AutoReadTimer = vfn.timer_start(1000, function()
    vim.cmd([[silent! checktime]])
end, { ["repeat"] = -1 })

-- Autocommand group for configuration
_G.le_group = vapi.nvim_create_augroup("LeConfiguration", { clear = true })
_G["le-group"] = _G.le_group

-- This is for sourcing on configuration change
vapi.nvim_create_autocmd({ "BufWritePost" }, {
    group = le_group,
    pattern = { "init.lua", "init.vim" },
    desc = "Auto re-source configuration files.",
    -- command = "source <afile> | PackerCompile",
    command = "source $MYVIMRC | PackerCompile",
})

-- Force reload specific modules for faster development
if not is_startup then
    local plenary = require("plenary")
    plenary.reload.reload_module("le.libf")
    plenary.reload.reload_module("le.libl")
    plenary.reload.reload_module("le.atlas")
end

-- Shortcuts to Table Functions
_G.t = {
    filter = vim.tbl_filter,
    contains = vim.tbl_contains,
    map = vim.tbl_map,
    count = vim.tbl_count,
    extend = vim.tbl_extend,
    deep_extend = vim.tbl_deep_extend,
    isempty = vim.tbl_isempty,
    add_reverse_lookup = vim.tbl_add_reverse_lookup,
    get = vim.tbl_get,
    values = vim.tbl_values,
    keys = vim.tbl_keys,
    flatten = vim.tbl_flatten,
    islist = vim.tbl_islist,
    range = vfn.range,
}
_G.t = vim.tbl_extend("force", table, _G.t)

-- Metatable shenanigans
local String = getmetatable("")
function String.__index:char_at(i)
    if i > #self then
        return nil
    end
    return self:sub(i, i)
end

-- Load Helper Modules
_G.lf = require("le.libf") -- My Helper module (Fennel)
_G.ll = require("le.libl") -- My Helper module (Lua)

vapi.nvim_create_user_command("GetDate", function(command)
    local time = lf.get_date(command.args)
    if type(time) == "string" then
        lf.set_register_and_notify(time)
    else
        P(time)
    end
    return time
end, { nargs = "?" })

-- Setup Evaluation w/ Lua
-- TODO: Make this much better
vapi.nvim_create_autocmd({ "BufEnter" }, {
    group = le_group,
    desc = "Add Lua Keymaps",
    pattern = "*.lua",
    callback = function(event)
        wk.register({
            name = "(e)valuate",
            -- Super Ad-Hoc Evaluation. Try to find a better way.
            l = {
                function()
                    local to_eval = loadstring(
                        "P(" .. vapi.nvim_get_current_line() .. ")",
                        nil
                    )
                    if to_eval then
                        setfenv(to_eval, t.extend("force", cfg_env, _G))
                        to_eval()
                    else
                        lf.notify_error("Failed to Evaluate Line")
                    end
                end,
                "(e)valuate (l)ine",
            },
        }, { prefix = "<Leader>e", buffer = event.buf })
    end,
})

-------------------------
-- Make Neovim Pretty! --
-------------------------

require("le.gui")
require("le.colorscheme")
require("le.dressing")
require("le.notify")
require("le.colorizer")
require("le.haskell")

-- Formatting
vapi.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
wk.register({
    c = {
        f = { vim.lsp.buf.formatting, "(c)ode (f)ormatting" },
        a = { vim.lsp.buf.code_action, "(c)ode (a)ction" },
        h = { vim.lsp.buf.hover, "(c)ode (h)over" },
    },
}, { prefix = "<Leader>" })

----------------------
-- Writing Setup ✍️  --
------------------- --

-- Markdown Improvements
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_strikethrough = 1
vim.g.vim_markdown_auto_insert_bullets = 0
vim.g.vim_markdown_new_list_item_indent = 0
-- Why doesn't this language aliasing work?
vim.g.vim_markdown_fenced_languages = {
    "dataviewjs=javascript",
    "dataview=sql",
}

-- Wiki Vim
vim.g.wiki_name = "- Index -"
vim.g.wiki_mappings_use_defaults = "none"
vim.g.wiki_root = "~/Documents/Notes"
vim.g.wiki_filetypes = { "md", "markdown" }
vim.g.wiki_journal = {
    name = "Journal/Weekly Reviews",
    frequency = "weekly",
    date_format = {
        daily = "%Y-%m-%d",
        weekly = "%Y-W%V",
    },
}
vim.g.wiki_index_name = "- Index -.md"
vim.g.wiki_link_toggle_on_follow = false
vapi.nvim_create_autocmd({ "BufEnter" }, {
    group = le_group,
    desc = "Set note-taking keybindings for current buffer.",
    pattern = { "*.md", "*.mdx", "*.txt", "*.wiki" },
    callback = function(event)
        wk.register({
            ["<Leader>n"] = {
                name = "(n)otes",
                i = { "<Plug>(wiki-index)", "(n)ote (i)ndex" },
                b = { "<Plug>(wiki-graph-find-backlinks)", "(n)ote (b)acklinks" },
                t = { ":Telescope heading<Enter>", "(n)ote (t)able of contents" },
                w = {
                    name = "(w)eekly",
                    w = { "<Plug>(wiki-journal)", "(n)ote (w)eekly" },
                    l = { "<Plug>(wiki-journal-next)", "(n)ote (w)eekly next" },
                    h = { "<Plug>(wiki-journal-prev)", "(n)ote (w)eekly previous" },
                },
            },
            ["<Leader>el"] = { ":CarrotEval<Enter>", "(e)valuate (l)ua code block" },
            ["<Leader><Leader><Enter>"] = {
                "<Plug>(wiki-link-toggle)",
                "Create or Toggle Link",
            },
        }, { buffer = event.buf })
    end,
})

-- Custom Note Workflow Stuff
local le_atlas = require("le.atlas")
le_atlas.setup({ wk = wk })

-- Random FD command XD
vapi.nvim_create_user_command("FD", function(command)
    lf.fd_async({
        args = { command.args },
        callback = P,
    })
end, { nargs = "?" })

require("le.statusline")

-- Escaped Strings are Pain in Fennel
HeaderString = [[
__      __          _                                              _  __  __   __
\ \    / / ___     | |     __      ___    _ __     ___      o O O | |/ /  \ \ / /
 \ \/\/ / / -_)    | |    / _|    / _ \  | '  \   / -_)    o      | ' <    \ V /
  \_/\_/  \___|   _|_|_   \__|_   \___/  |_|_|_|  \___|   TS__[O] |_|\_\   _\_/_
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======|_|"""""|_| """"|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-']]
require("le.starter")

require("le.bufremove")

require("le.bufferline")

require("le.indentscope")

require("le.focus")

------------------------------
-- Useful Utilities Setup ⚙️ --
------------------------------

require("le.conjure")

require("le.zen-mode")

require("le.winshift")

-- Gitsigns (Sidebar Git Indicators)
require("gitsigns").setup({
    current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 100,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary> ",
})
wk.register({
    ["<Leader>"] = {
        g = {
            name = "(g)it",
            b = { ":Gitsigns blame_line<Enter>", "(g)it (b)lame line" },
            B = {
                ":Gitsigns toggle_current_line_blame<Enter>",
                "toggle (g)it (B)lame line",
            },
            d = { ":Gitsigns diffthis<Enter>", "(g)it (d)iff" },
            D = { ":Gitsigns toggle_deleted<Enter>", "(g)it toggle (D)eleted" },
            p = { ":Gitsigns preview_hunk<Enter>", "(g)it (p)review hunk" },
            RRR = { ":Gitsigns reset_hunk<Enter>", "(g)it (R)eset hunk (DANGER!!!)" },
        },
    },
})

require("le.leap")

require("le.neogit")

-- Floating Terminal Stuff
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
vim.g.autoclose = 1
-- Mapping in terminal mode is a bit weird in which-key right now
local term = function(mapping)
    return vapi.nvim_replace_termcodes(mapping, true, true, true)
end
wk.register({ ["<C-t>"] = { ":FloatermToggle<Enter>", "Open Terminal" } })
wk.register({
    ["<C-t>"] = { term("<C-\\><C-n>:FloatermToggle<Enter>"), "Close Terminal" },
    ["<C-n>"] = { term("<C-\\><C-n>:FloatermNext<Enter>"), "Go To Next Terminal" },
    ["<C-p>"] = { term("<C-\\><C-n>:FloatermPrev<Enter>"), "Go To Previous Terminal" },
    ["<C-l>"] = { term("<C-\\><C-n>:FloatermNext<Enter>"), "Go To Next Terminal" },
    ["<C-h>"] = { term("<C-\\><C-n>:FloatermPrev<Enter>"), "Go To Previous Terminal" },
    ["<C-q>"] = {
        term("<C-\\><C-n>:FloatermKill<Enter>"),
        "Quit/Kill The Current Terminal",
    },
    ["<C-t><C-n>"] = { term("<C-\\><C-n>:FloatermNew<Enter>"), "Create New Terminal" },
}, { mode = "t" })
wk.register({
    ["<C-t>"] = { ":FloatTermSend<Enter>", "Send Lines to Terminal" },
}, { mode = "v" })

require("yanky").setup({})
vim.keymap.set("n", "y", "<Plug>(YankyYank)", {})
vim.keymap.set("x", "y", "<Plug>(YankyYank)", {})
vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)", {})
vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)", {})
vim.keymap.set("x", "p", "<Plug>(YankyPutAfter)", {})
vim.keymap.set("x", "P", "<Plug>(YankyPutBefore)", {})
vim.keymap.set("n", "gp", "<Plug>(YankyGPutAfter)", {})
vim.keymap.set("n", "gP", "<Plug>(YankyGPutBefore)", {})
vim.keymap.set("x", "gp", "<Plug>(YankyGPutAfter)", {})
vim.keymap.set("x", "gP", "<Plug>(YankyGPutBefore)", {})
vapi.nvim_set_keymap("n", "<c-n>", "<Plug>(YankyCycleForward)", {})
vapi.nvim_set_keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)", {})

require("le.cursorword")

-- Trailing Space Diagnostics
require("mini.trailspace").setup({})
-- Disable Trailing Space Highlights in Certain Buffers
vapi.nvim_create_autocmd({ "BufEnter" }, {
    group = le_group,
    desc = "Disable trailing space highlighting in certain buffers.",
    callback = function()
        local bufferName = vapi.nvim_eval([[bufname()]])
        local tabPageNumber = vapi.nvim_eval([[tabpagenr()]])
        if bufferName == "NvimTree_" .. tabPageNumber then
            MiniTrailspace.unhighlight()
        end
    end,
})
-- Trim Space on Save
vapi.nvim_create_autocmd({ "BufWritePre" }, {
    group = le_group,
    desc = "Trim trailing spaces on save.",
    callback = function()
        MiniTrailspace.trim()
    end,
})

require("le.comment")

-- Session Management
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
require("mini.sessions").setup({
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
        MiniSessions.write("Last Session.vim", {})
    end,
})
local session_save_wrapper = function(input)
    if not input or input == "" or input == "null" then
        if vim.v.this_session and vim.v.this_session ~= "" then
            MiniSessions.write(nil, {})
            return
        end
        lf.notify_error("Please Give Session Name")
    elseif not pcall(MiniSessions.write, input .. ".vim", {}) then
        lf.notify_error("Session Write Has Failed (For Unknown Reasons)")
    end
end
vapi.nvim_create_user_command("SessionSave", function(command)
    session_save_wrapper(command.args)
end, { nargs = "?" })
-- TODO: Clean this up
wk.register({
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
            for detected, _ in pairs(MiniSessions.detected) do
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
                vim.ui.select({ "Yes Save", "No Just Leave" }, {
                    prompt = 'Save Session "' .. current_session .. '" Before Leaving?',
                }, function(_, index_selection)
                    if index_selection == 1 then
                        MiniSessions.write(nil)
                    end
                    MiniSessions.select("read")
                end)
            end
        end,
        "(s)ession (l)oad <Session Name>",
    },
    ["<Leader>sL"] = {
        function()
            MiniSessions.read(nil, {})
        end,
        "current (s)ession re(L)oad",
    },
    ["<Leader>sd"] = {
        function()
            MiniSessions.select("delete", { force = true })
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

require("mini.surround").setup({
    custom_surroundings = {
        ["|"] = { output = { left = "|", right = "|" } },
    },
    mappings = {
        add = "ys",
        delete = "ds",
        find = ">S",
        find_left = "<s",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
    },
})

-- Lua Pad (Quick Lua Testing)
require("luapad").config({
    count_limit = 5e4,
    print_highlight = "DiagnosticVirtualTextInfo",
    on_init = function() end,
})
wk.register({
    ["<Leader>e"] = {
        name = "(e)valuate",
        p = { ":Luapad<Enter>", "(e)valuate with lua(p)ad" },
    },
}, {})
vapi.nvim_create_user_command("Luapad", function()
    vapi.nvim_command([[botright vsplit ~/tmp/luapad.lua]])
    require("luapad.evaluator")
        :new({
            buf = 0,
            context = _G.cfg_env,
        })
        :start()
end, {})

-- HTTP Testing
require("rest-nvim").setup({
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Keep the http file buffer above|left when split horizontal|vertical
    result_split_in_place = false,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Highlight request on run
    highlight = {
        enabled = true,
        timeout = 150,
    },
    result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
    },
    -- Jump to request line on run
    jump_to_request = false,
    env_file = ".env",
    custom_dynamic_variables = {},
    yank_dry_run = true,
})
vapi.nvim_create_autocmd({ "BufEnter" }, {
    group = le_group,
    pattern = { "*.http" },
    callback = function(event)
        wk.register({
            ["<Enter>"] = { "<Plug>RestNvim", "Run HTTP Request" },
            ["<Leader><Enter>"] = { "<Plug>RestNvimPreview", "Run HTTP Request" },
        }, { buffer = event.buf })
    end,
})

------------------------
-- Telescope Setup 🔭 --
------------------------

-- local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                -- ["<Esc>"] = actions.close,
            },
        },
        layout_config = {
            prompt_position = "top",
        },
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        set_env = { ["COLORTERM"] = "truecolor" },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_cursor({}),
        },
        heading = {
            treesitter = true,
        },
        gitmoji = {
            action = function(entry)
                vim.ui.input(
                    { prompt = "Enter commit msg: " .. entry.value .. " " },
                    function(msg)
                        if not msg then
                            return
                        end
                        local commit_message = entry.value .. " " .. msg
                        lf.set_register_and_notify(commit_message)
                    end
                )
            end,
        },
    },
})

require("telescope-emoji").setup({
    action = function(emoji)
        require("yanky").history.push({
            regcontents = emoji.value,
            regtype = "v",
        })
        lf.set_register_and_notify(emoji.value)
    end,
})

telescope.load_extension("fzf")
telescope.load_extension("emoji")
telescope.load_extension("packer")
telescope.load_extension("gitmoji")
telescope.load_extension("heading")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")
telescope.load_extension("yank_history")

vapi.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function()
        vim.opt_local.wrap = true
    end,
    -- TODO: Open issue on why wrap only works after you go to the file
    -- then come back
})

-- Telescope Keymaps
wk.register({
    ["<Leader>"] = {
        f = {
            name = "(f)ind something (Telescope Pickers)",
            a = { ":Telescope<Enter>", "(f)ind (a)ll built in pickers" },
            b = { ":Telescope buffers<Enter>", "(f)ind (b)uffers" },
            B = { ":Lexplore 30<Enter>", "(f)ile (B)rowser" },
            c = { ":Telescope commands<Enter>", "(f)ind (c)ommands" },
            d = { ":Telescope diagnostics<Enter>", "(f)ind (d)iagnostics" },
            e = { ":Telescope emoji<Enter>", "(f)ind (e)mojis! 😎" },
            ["<C-e>"] = {
                ":Telescope symbols<Enter>",
                "(f)ind (e)mojis/symbols! (Advanced) 😎 λ",
            },
            -- TODO: Configure file browser to do things?
            E = { ":Telescope file_browser<Enter>", "(f)ile (E)xplorer" },
            f = { ":Telescope find_files<Enter>", "(f)ind (f)iles" },
            g = { ":Telescope live_grep<Enter>", "(g)rep project" },
            h = { ":Telescope help_tags<Enter>", "(f)ind (h)elp" },
            k = { require("legendary").find, "(f)ind (k)eymaps" },
            m = { ":Telescope marks<Enter>", "(f)ind (m)arks" },
            M = { ":Telescope man_pages<Enter>", "(f)ind (M)an pages" },
            p = { ":Telescope packer<Enter>", "(f)ind (p)acker/(p)lugins" },
            r = { ":Telescope oldfiles<Enter>", "(f)ind (r)ecent files" },
            t = { ":Telescope treesitter<Enter>", "(f)ind (t)reesitter symbols" },
            y = { ":Telescope yank_history<Enter>", "(f)ind (y)ank history" },
        },
        ["/"] = { ":Telescope current_buffer_fuzzy_find<Enter>", "Fuzzy Find In File" },
        ["?"] = { ":Telescope live_grep<Enter>", "Fuzzy Find Across Project" },
        gm = { ":Telescope gitmoji<Enter>", "(g)it (m)essage helper" },
    },
    gr = { ":Telescope lsp_references<Enter>", "Find References" },
    ["z="] = { ":Telescope spell_suggest<Enter>", "Spelling Suggestions" },
})

-------------------------
-- Treesitter Setup 🌳 --
-------------------------

require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
        disable = { "markdown" },
        additional_vim_regex_highlighting = { "markdown" },
    },
    context_commentstring = { enable = true },
    ensure_installed = {
        "c",
        "lua",
        "rust",
        "bash",
        "clojure",
        "cmake",
        "css",
        "commonlisp",
        "erlang",
        "fennel",
        "go",
        "glsl",
        "haskell",
        "java",
        "html",
        "http",
        "javascript",
        "json",
        "latex",
        "make",
        "markdown",
        "ocaml",
        "python",
        "regex",
        "scheme",
        "svelte",
        "swift",
        "toml",
        "vim",
        "yaml",
        "wgsl",
        "tsx",
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = { -- TODO: Look more at these
            init_selection = [[\\ti]],
            node_incremental = [[\\tk]],
            scope_incremental = [[\\tK]],
            node_decremental = [[\\tj]],
        },
    },
    refactor = {
        -- highlight_current_scope = { enable = true },
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<Leader>rn",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition_lsp_fallback = "gd",
                goto_next_usage = "g>",
                goto_previous_usage = "g<",
            },
        },
    },
    textobjects = {
        lsp_interop = { enable = true },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["a?"] = "@conditional.outer",
                ["i?"] = "@conditional.inner",
                ["aC"] = "@call.outer",
                ["iC"] = "@call.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aP"] = "@parameter.outer",
                ["iP"] = "@parameter.inner",
                ["ak"] = "@comment.outer",
                ["as"] = "@statement.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<Leader>csn"] = "@parameter.inner",
            },
            swap_previous = {
                ["<Leader>csp"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]c"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]C"] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[c"] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[C"] = "@class.outer",
            },
        },
    },
})

require("spellsitter").setup()

if is_going_hard then
    require("nvim-gps").setup({
        separator = " ▶ ",
    })
end

---------------------------------------------
-- Language Server Protocol (LSP) Setup 💡 --
---------------------------------------------

local lsp_servers = {
    "rust_analyzer",
    "sumneko_lua",
    "clangd",
    "pyright",
    "tsserver",
    "cssls",
    "html",
    "emmet_ls",
    "hls",
    "bashls",
    "cmake",
    "yamlls",
    "vimls",
}

require("nvim-lsp-installer").setup({
    ensure_installed = lsp_servers,
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗",
        },
    },
})

-- Null-ls Hook Setup
local null_ls = require("null-ls")
null_ls.setup({
    autostart = true,
    sources = {
        -- Formatting
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.fnlfmt,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.fourmolu,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.trim_newlines,

        -- Code Actions
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.code_actions.gitsigns,

        -- Diagnostics
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.flake8,
    },
})

local on_attach = function(_, bufnr)
    -- TODO: Replace vim.lsp with telescope pickers when possible
    wk.register({
        g = {
            name = "(g)o to",
            d = { ":Telescope lsp_definitions<Enter>", "(g)o to (d)efinition" },
            D = { vim.lsp.buf.declaration, "(g)o to (D)eclaration" },
            i = { vim.lsp.buf.implementation, "(g)o to (i)mplementation" },
            r = { vim.lsp.buf.references, "(g)o to (r)eferences" },
        },
        ["<Leader>"] = {
            c = {
                name = "(c)ode",
                s = { vim.lsp.buf.signature_help, "(c)ode (s)ignature" },
                t = { vim.lsp.buf.type_definition, "(c)ode (t)ype" },
            },
            fs = { ":Telescope lsp_document_symbols<Enter>", "(s)ymbols" },
            rn = { vim.lsp.buf.rename, "(r)e(n)ame symbol" },
        },
    }, { buffer = bufnr })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local runtime_path = vim.split(package.path, ";")
t.insert(runtime_path, "lua/?.lua")
t.insert(runtime_path, "lua/?/init.lua")

local lspconfig = require("lspconfig")
local luadev = require("lua-dev").setup({
    library = {
        plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    runtime_path = true,
    lspconfig = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        -- Neovim Stuff
                        "vim",
                        "P",
                        "MiniSessions",
                        "MiniStatusline",
                        "MiniTrailspace",
                        "MiniBufremove",

                        -- AwesomeWM Stuff
                        "awesome",
                        "screen",
                        "client",
                        "root",
                        "tag",
                        "widget",
                    },
                },
            },
        },
    },
})
local lsp_settings = {
    -- My Old Lua LSP settings (Might be useful for non vim projects?)
    -- sumneko_lua = {
    --     settings = {
    --         Lua = {
    --             runtime = { version = "LuaJIT", path = runtime_path },
    --             diagnostics = { globals = { "vim" } },
    --             -- Make the server aware of Neovim runtime files
    --             workspace = { library = vapi.nvim_get_runtime_file("", true) },
    --         },
    --     },
    -- }
    sumneko_lua = luadev,
}

if is_startup then -- Only load LSPs on startup
    for _, server in ipairs(lsp_servers) do
        local setup = {}
        if lsp_settings[server] ~= nil then
            setup = lsp_settings[server]
        end
        setup.on_attach = on_attach
        setup.capabilities = capabilities
        lspconfig[server].setup(setup)
    end
end

require("lsp_signature").setup({
    hint_enable = true,
    hint_prefix = "✅ ",
})

-------------------------
-- Completion Setup ✅ --
-------------------------

local luasnip = require("luasnip")

-- nvim-cmp setup
local lspkind = require("lspkind")
local cmp = require("cmp")
cmp.setup({
    experimental = {
        ghost_text = true,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.close(),
            c = cmp.mapping.close(),
        }),
        -- Enter Auto Confirm
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        -- Only use Tab for snippets
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        -- Tab Cycling
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_prev_item()
        --     elseif luasnip.jumpable(-1) then
        --         luasnip.jump(-1)
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "emoji", option = { insert = true } },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "treesitter" },
        { name = "conjure" },
        { name = "path" },
        { name = "luasnip" },
        { name = "calc" },
    }, {
        { name = "omni" },
        { name = "spell" },
        { name = "fuzzy_buffer", keyword_length = 5 },
        { name = "buffer" },
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = {
                omni = "[Omni]",
                buffer = "[Buffer]",
                conjure = "[Conjure]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                treesitter = "[TS]",
                nvim_lsp_signature_help = "[LSP]",
                path = "[Path]",
                emoji = "[Emoji]",
                calc = "[Calc]",
                spell = "[Spell]",
                fuzzy_buffer = "[FzyBuf]",
                cmdline_history = "[CMDHis]",
            },
            before = function(entry, vim_item)
                pcall(function()
                    vim_item.menu = (vim_item.menu or "")
                        .. " "
                        .. entry:get_completion_item().detail
                end)
                return vim_item
            end,
        }),
    },
})

-- TODO: Make completion stuff my theme later (someday... maybe)
vim.cmd([[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])

for _, command_type in pairs({ ":", "@" }) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "cmdline" },
            { name = "calc" },
            { name = "cmdline_history" },
            { name = "path" },
        },
    })
end
for _, command_type in pairs({ "/", "?" }) do
    require("cmp").setup.cmdline(command_type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "nvim_lsp_document_symbol" },
            { name = "buffer" },
            { name = "fuzzy_buffer" },
            { name = "cmdline_history" },
        },
    })
end

-------------------
-- Miscellaneous --
-------------------

-- Misc Mappings
wk.register({
    s = {
        name = "(s)essions",
    },
    ["<Leader>s"] = {
        name = "(s)pelling",
        a = "Add to Dictionary",
        r = "Remove from Dictionary",
        u = "Undo Last Dictionary Action",
        l = "Go to Next Spelling Error",
        h = "Go to Previous Spelling Error",
    },
    w = { name = "(w)indowing (Also Ctrl-w)" },
    c = {
        ["-"] = "Comment Banner (--)",
        ["="] = "Comment Banner (==)",
        ["/"] = "Comment Banner (//)",
        f = { vim.lsp.buf.formatting, "(c)ode (f)ormatting" },
    },
    ["<Leader>"] = {
        q = "(q)uit all",
        r = {
            function()
                vim.cmd([[source $MYVIMRC]])
                lf.notify_info("Configuration Reloaded")
            end,
            "(r)e-source config",
        },
    },
}, { prefix = "<Leader>" })

-- For REPL or Debug Purposes
_G.cfg_env = lf.get_locals()
