--           _____                    _____          
--          /\    \                  /\    \         
--         /::\    \                /::\    \        
--        /::::\    \              /::::\    \       
--       /::::::\    \            /::::::\    \      
--      /:::/\:::\    \          /:::/\:::\    \     
--     /:::/__\:::\    \        /:::/  \:::\    \    
--    /::::\   \:::\    \      /:::/    \:::\    \   
--   /::::::\   \:::\    \    /:::/    / \:::\    \  
--  /:::/\:::\   \:::\____\  /:::/    /   \:::\    \ 
-- /:::/  \:::\   \:::|    |/:::/____/     \:::\____\
-- \::/   |::::\  /:::|____|\:::\    \      \::/    /
--  \/____|:::::\/:::/    /  \:::\    \      \/____/ 
--        |:::::::::/    /    \:::\    \             
--        |::|\::::/    /      \:::\    \            
--        |::| \::/____/        \:::\    \           
--        |::|  ~|               \:::\    \          
--        |::|   |                \:::\    \         
--        \::|   |                 \:::\____\        
--         \:|   |                  \::/    /        
--          \|___|                   \/____/         
--
--           _____            _____                    _____          
--          /\    \          /\    \                  /\    \         
--         /::\____\        /::\____\                /::\    \        
--        /:::/    /       /:::/    /               /::::\    \       
--       /:::/    /       /:::/    /               /::::::\    \      
--      /:::/    /       /:::/    /               /:::/\:::\    \     
--     /:::/    /       /:::/    /               /:::/__\:::\    \    
--    /:::/    /       /:::/    /               /::::\   \:::\    \   
--   /:::/    /       /:::/    /      _____    /::::::\   \:::\    \  
--  /:::/    /       /:::/____/      /\    \  /:::/\:::\   \:::\    \ 
-- /:::/____/       |:::|    /      /::\____\/:::/  \:::\   \:::\____\
-- \:::\    \       |:::|____\     /:::/    /\::/    \:::\  /:::/    /
--  \:::\    \       \:::\    \   /:::/    /  \/____/ \:::\/:::/    / 
--   \:::\    \       \:::\    \ /:::/    /            \::::::/    /  
--    \:::\    \       \:::\    /:::/    /              \::::/    /   
--     \:::\    \       \:::\__/:::/    /               /:::/    /    
--      \:::\    \       \::::::::/    /               /:::/    /     
--       \:::\    \       \::::::/    /               /:::/    /      
--        \:::\____\       \::::/    /               /:::/    /       
--         \::/    /        \::/____/                \::/    /        
--          \/____/          ~~                       \/____/         

-- ===================================================================
-- Hello and welcome to derpyasianpanda's rc.lua for the "Awesome"
-- window manager. I hope you enjoy your stay!
-- ===================================================================

-- ==========================
-- Initializing Prerequisites
-- ==========================

-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget/Layout library
local wibox = require("wibox")

-- Theme library
local beautiful = require("beautiful")

-- Notification libraries
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- ============
-- User options
-- ============

user = {
    terminal = "kitty -1",
    editor_cmd = "kitty -1 --class editor -e vim",
    editor = os.getenv("EDITOR") or "vim",
    browser = "google-chrome-stable",
    theme = "static",
    modkey = "Mod1",
}

-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.spiral,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}

-- Theme Initialization
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" ..
    user.theme .. "/theme.lua")

-- ==============
-- Error handling
-- ==============

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- ==========
-- Menu Setup
-- ==========

-- Create a launcher widget and a main menu
myawesomemenu = {
   { "Hotkeys", function() 
       hotkeys_popup.show_help(nil, awful.screen.focused())
   end },
   { "Docs", "xdg-open /usr/share/doc/awesome/doc/index.html" },
   { "Config", user.editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { 
    { "Awesome", myawesomemenu, beautiful.awesome_icon },
    { "Terminal", user.terminal }
}})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

menubar.utils.terminal = user.terminal

-- ===============
-- Wallpaper Setup
-- ===============

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Dynamic Wallpaper Setting
script_path = gears.filesystem.get_configuration_dir() .. "scripts/"
if beautiful.dynamic_wallpaper then
    bg_path = gears.filesystem.get_configuration_dir() .. "themes/" .. user.theme .. "/background.mp4"
    awful.spawn.with_shell(script_path .. "setlivewallpaper.sh " .. bg_path)
else
    awful.spawn.with_shell(script_path .. "killlivewallpapers.sh")
end

-- ==================
-- Wibar/Widget Setup
-- ==================

local mytextclock = wibox.widget.textclock(" ~ %a %b %e, %H:%M ~ ")

local taglist_buttons = gears.table.join(
    awful.button(
        { }, 1,
        function(t) t:view_only() end
    ),
    awful.button(
        { user.modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button(
        { }, 3,
        awful.tag.viewtoggle
    ),
    awful.button(
        { user.modkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        { }, 4,
        function(t) awful.tag.viewnext(t.screen) end
    ),
    awful.button(
        { }, 5,
        function(t) awful.tag.viewprev(t.screen) end
    )
)

local tasklist_buttons = gears.table.join(
    awful.button(
        { }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    { raise = true }
                )
            end
        end
    ),
    awful.button(
        { }, 3,
        function()
            awful.menu.client_list({
                theme = { width = 250 }
            })
        end
    ),
    awful.button(
        { }, 4,
        function ()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        { }, 5,
        function ()
            awful.client.focus.byidx(-1)
        end
    )
)

-- Extra custom widgets to use
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")

local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")

local function padding_widget (pad_size)
    return wibox.widget.textbox(string.rep(" ", pad_size))
end

-- Add a wibar to each screen
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Serves as padding for the top widgets
    s.mywibox = awful.wibar({ position = "top", screen = s, opacity = 0, height = 50 })
    s.mywibox:setup();

    s.tag_wibox = wibox({
        border_width = 12,
        border_color = beautiful.bg_normal,
        ontop = false,
        x = s.geometry["x"] + 8 * 1.5,
        y = s.geometry["y"] + 7,
        width = 112,
        height = 25,
        screen = s,
        visible = true,
    })

    s.tag_wibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
    }

    s.time_bar = wibox({
        border_width = 12,
        border_color = beautiful.bg_normal,
        ontop = false,
        x = s.geometry["x"] + s.geometry["width"] / 2 - 125,
        y = s.geometry["y"] + 7,
        width = 250,
        height = 25,
        screen = s,
        visible = true,
    })
              
    s.time_bar:setup {
        layout = wibox.layout.align.horizontal,
        padding_widget(1),
        {
            layout = wibox.layout.align.horizontal,
            mytextclock,
        },
        padding_widget(1),
    }

    s.util_bar = wibox({
        -- TODO: Find out why borders are so weird
        border_width = 12,
        border_color = beautiful.bg_normal,
        ontop = false,
        width = 100,
        height = 25,
        screen = s,
        visible = true,
    })
    s.util_bar.y = s.geometry["y"] + 7

    if s.index == 1 then
        s.util_bar.x = s.geometry["x"] + s.geometry["width"] - 100 - 12 * 1.5 * 2,
        s.util_bar:setup {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.align.horizontal,
                wibox.widget.systray(),
            },
        }
    else
        s.util_bar.width = 300
        s.util_bar.x = s.geometry["x"] + s.geometry["width"] - s.util_bar.width - 35
        s.util_bar:setup {
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.align.horizontal,
                spotify_widget({
                    play_icon = beautiful.note_on,
                    pause_icon = beautiful.note,
                    max_length = 18,
                    font = "Monaco 8"
                })
            },
        }
    end
            
end)
-- }}}

-- ==================
-- Bindings/Shortcuts
-- ==================

-- Mouse
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Global Keys
globalkeys = gears.table.join(
    awful.key(
        { user.modkey }, "s",
        hotkeys_popup.show_help,
        { description="show help", group="awesome" }
    ),
    awful.key(
        { user.modkey }, "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    awful.key(
        { user.modkey }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    awful.key(
        { user.modkey }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),
    awful.key({ user.modkey }, "j",
        function () awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ user.modkey }, "k",
        function () awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key(
        { user.modkey }, "w",
        function () mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),

    -- Layout manipulation
    awful.key(
        { user.modkey, "Shift" }, "j", 
        function () awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "k",
        function () awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "j",
        function () awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }
    ),
    awful.key(
        { user.modkey, "Control" }, "k",
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),
    awful.key(
        { user.modkey }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),
    awful.key(
        { user.modkey }, "l",
        function () awful.tag.incmwfact(0.025) end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key(
        { user.modkey }, "h",
        function () awful.tag.incmwfact(-0.025) end,
        { description = "decrease master width factor", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "h",
        function () awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "l",
        function () awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "h",
        function () awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "l",
        function () awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),
    awful.key(
        { user.modkey }, "space",
        function () awful.layout.inc(1) end,
        { description = "select next", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "space",
        function () awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
              c:emit_signal(
                  "request::activate", "key.unminimize", {raise = true}
              )
            end
        end,
        { description = "restore minimized", group = "client"}
    ),

    -- Standard programs
    awful.key(
        { user.modkey }, "Return",
        function () awful.spawn(user.terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),
    awful.key(
        { user.modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key(
        { user.modkey }, "b", function () awful.spawn(user.browser) end,
        { description = "open browser", group = "apps" }
    ),
    awful.key(
        { user.modkey }, "d", function () awful.spawn("discord") end,
        { description = "open discord", group = "apps" }
    ),
 
    -- Rofi Prompts
    awful.key(
        { user.modkey }, "r",
        function() awful.spawn("rofi -show run") end,
        { description = "show the run menu", group = "launcher" }
    ),
    awful.key(
        { user.modkey }, "p",
        function() awful.spawn("rofi -show drun") end,
        { description = "show the application launcher", group = "launcher" }
    ),
    awful.key(
        { user.modkey }, "Tab",
        function () awful.spawn("rofi -show window") end,
        { description = "open window list", group = "custom" }
    )
)

clientkeys = gears.table.join(
    awful.key(
        { user.modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key(
        { user.modkey }, "c",
        function (c) c:kill() end,
        { description = "close", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),
    awful.key(
        { user.modkey }, "o",
        function (c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }
    ),
    awful.key(
        { user.modkey }, "t",
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),
    awful.key(
        { user.modkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }
    ),
    awful.key(
        { user.modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { description = "(un)maximize", group = "client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        { description = "(un)maximize vertically", group = "client" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

-- Taglist Controls
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,

        -- View tag only.
        awful.key(
            { user.modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}
        ),

        -- Toggle tag display.
        awful.key(
            { user.modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),

        -- Move client to tag.
        awful.key(
            { user.modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i] if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}
        ),
                  
        -- Toggle tag on focused client.
        awful.key(
            { user.modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        )
    )
end

clientbuttons = gears.table.join(
    awful.button(
        { }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        { user.modkey }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        { user.modkey }, 3,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true }},
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage",
    function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Sloppy Focus
client.connect_signal("mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal("focus",
    function(c) c.border_color = beautiful.border_focus end
)
client.connect_signal("unfocus",
    function(c) c.border_color = beautiful.border_normal end
)

-- ===============
-- Autostart Setup
-- ===============

awful.spawn.with_shell("picom -cb --experimental-backends")

