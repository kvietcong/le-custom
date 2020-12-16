--       ___           ___
--      /\  \         /\  \
--     /::\  \       /::\  \
--    /:/\:\  \     /:/\:\  \
--   /::\~\:\  \   /:/  \:\  \
--  /:/\:\ \:\__\ /:/__/ \:\__\
--  \/_|::\/:/  / \:\  \  \/__/
--     |:|::/  /   \:\  \
--     |:|\/__/     \:\  \
--     |:|  |        \:\__\
--      \|__|         \/__/

--                     ___           ___
--                    /__/\         /  /\
--                    \  \:\       /  /::\
--   ___     ___       \  \:\     /  /:/\:\
--  /__/\   /  /\  ___  \  \:\   /  /:/~/::\
--  \  \:\ /  /:/ /__/\  \__\:\ /__/:/ /:/\:\
--   \  \:\  /:/  \  \:\ /  /:/ \  \:\/:/__\/
--    \  \:\/:/    \  \:\  /:/   \  \::/
--     \  \::/      \  \:\/:/     \  \:\
--      \__\/        \  \::/       \  \:\
--                    \__\/         \__\/


-- ===============================================================
-- ===============================================================
--
-- Hello and welcome to derpyasianpanda's rc.lua for the "Awesome"
-- window manager. I hope you enjoy your stay!
--
-- ===============================================================
-- ===============================================================


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
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Notification libraries
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Pre-made widget library
local lain = require("lain")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- ============
-- User options
-- ============

user = {
    terminal = "kitty",
    editor_cmd = "kitty --class editor -e vim",
    editor = os.getenv("EDITOR") or "vim",
    browser = "google-chrome-stable",
    theme = "static",
    modkey = "Mod1",
    torrent = "qbittorrent",
}

-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
    --  awful.layout.suit.max,
    --  awful.layout.suit.spiral.dwindle,
    --  awful.layout.suit.spiral,
    --  awful.layout.suit.tile.top,
    --  awful.layout.suit.fair,
    --  awful.layout.suit.fair.horizontal,
    --  awful.layout.suit.tile.left,
    --  awful.layout.suit.tile.bottom,
    --  awful.layout.suit.corner.nw,
    --  awful.layout.suit.magnifier,
    --  awful.layout.suit.corner.ne,
    --  awful.layout.suit.corner.sw,
    --  awful.layout.suit.corner.se,
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
local menu_awesome = {
   { "Hotkeys", function ()
       hotkeys_popup.show_help(nil, awful.screen.focused())
   end },
   { "Docs", user.browser .. " /usr/share/doc/awesome/doc/index.html" },
   { "Config", user.editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function () awesome.quit() end },
}

local menu_apps = {
   { "Browser", user.browser },
   { "Torrents", user.torrent },
   { "Discord", "discord" },
   { "Spotify", user.browser .. " https://open.spotify.com/" },
}

local menu_root = awful.menu({ items = {
    { "Awesome", menu_awesome, beautiful.awesome_icon },
    { "Applications", menu_apps },
    { "Terminal", user.terminal },
}})

-- TODO: Figure out why this doesn't work
menu_root.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
end

awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = menu_root
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
local script_path = gears.filesystem.get_configuration_dir() .. "scripts/"
if beautiful.dynamic_wallpaper then
    local bg_path = gears.filesystem.get_configuration_dir() ..
        "themes/" .. user.theme .. "/background.mp4"
    awful.spawn.with_shell(script_path .. "setlivewallpaper.sh " .. bg_path)
else
    awful.spawn.with_shell(script_path .. "killlivewallpapers.sh")
end

-- ==================
-- Wibar/Widget Setup
-- ==================

-- Date/Time
local date = wibox.widget.textclock("%a, %b.%e")
local time = wibox.widget.textclock("%H:%M")
date.align = "center"
time.align = "center"

-- Taglist
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

-- (WIP) Power menu of some kind
local power_button = wibox.widget.imagebox(beautiful.shutdown)
power_button.forced_height = 25

power_button:buttons(awful.util.table.join(
    awful.button({}, 1, function () -- left click
        awful.spawn("")
    end)
))


-- PulseAudio Volume Controller
local volume_text = lain.widget.pulse {
    settings = function ()
        vlevel = volume_now.right .. "%"
        if volume_now.muted == "yes" then
            vlevel = "Mute"
        end
        widget:set_markup(vlevel)
    end
}

local volume = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.speaker,
            resize = true,
        }
    },
    volume_text.widget,
}

volume:buttons(awful.util.table.join(
    awful.button({}, 1, function () -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 3, function () -- right click
        os.execute(
            string.format("pactl set-sink-mute %s toggle", volume_text.device)
        )
        volume_text.update()
    end),
    awful.button({}, 4, function () -- scroll up
        os.execute(
            string.format("pactl set-sink-volume %s +1%%", volume_text.device)
        )
        volume_text.update()
    end),
    awful.button({}, 5, function () -- scroll down
        os.execute(
            string.format("pactl set-sink-volume %s -1%%", volume_text.device)
        )
        volume_text.update()
    end)
))

-- Battery Indicator
local battery_text = lain.widget.bat({
    settings = function ()
        widget.text =
            ((bat_now.perc == "N/A") and "?" or bat_now.perc) .. "%"
    end,
})

local battery = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 10,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.battery,
            resize = true,
        }
    },
    battery_text.widget,
}

-- CPU Indicator
local cpu_text = lain.widget.cpu({
    settings = function ()
        widget.text = cpu_now.usage .. "%"
    end,
})

local cpu = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 15,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.cpu,
            resize = true,
        }
    },
    cpu_text.widget,
}

-- Memory Indicator
local mem_text = lain.widget.mem({
    settings = function ()
        widget.text = mem_now.used / 1000 .. "GiB"
    end,
})

local mem = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 15,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.ram,
            resize = true,
        }
    },
    mem_text.widget,
}

-- Creates floating wibar sections
local wibar_section = function(current_screen, args)
    local section = wibox({
        screen = current_screen,
        height = args.height, width = args.width,
        border_width = beautiful.border_width,
        border_color = beautiful.bg_focus,
        x = current_screen.geometry.x + args.x,
        y = current_screen.geometry.y + args.y,
        bg = beautiful.bg_normal, visible = true,
        ontop = true, shape = gears.shape.rectangle,
        input_passthrough = false, type = "dock",
    })
    -- Border Radius
    section.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end

    -- Uncomment to change workspace area
    -- section:struts({ top = 0, bottom = 45 })

    section:setup {
        layout = wibox.layout.fixed.horizontal,
        args.widget
    }

    return section
end

-- Systray
local systray = wibox.widget.systray()
systray.visible = true
systray.forced_height = 25

-- Add a widgets to each screen
awful.screen.connect_for_each_screen(function(current_screen)
    set_wallpaper(current_screen)

    awful.tag({ " ", " ", " ", " ", " " }, current_screen, awful.layout.layouts[1])

    current_screen.systray = systray

    -- Imagebox which contains an icon indicating current layout
    current_screen.layoutbox = awful.widget.layoutbox(current_screen)
    current_screen.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    current_screen.taglist = awful.widget.taglist {
        screen  = current_screen,
        filter  = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.circle,
            spacing = 5,
            bg_focus = beautiful.fg_focus,
            bg_empty = beautiful.fg_minimize,
            bg_occupied = beautiful.fg_normal,
            font = "Monaco 6"
        },
        buttons = taglist_buttons,
    }
    
    -- Create a Wibar
    current_screen.wibar = {}

    current_screen.wibar.first = wibar_section(current_screen, {
        widget = {
            layout = wibox.layout.fixed.horizontal,
            {
                widget = wibox.container.margin,
                left = 15, {
                    layout = wibox.layout.fixed.horizontal,
                    {
                            widget = wibox.container.margin,
                            right = 5, top = 5, bottom = 5,
                            current_screen.layoutbox,
                    },
                    current_screen.taglist,
                }
            }
        },
        x = 10,
        y = current_screen.geometry.height - 40 - 10,
        width = 165, height = 40,
    })

    current_screen.wibar.second = wibar_section(current_screen, {
        widget = {
            widget = wibox.container.place,
            halign = "center", forced_width = 700,
            {
                widget = wibox.container.margin,
                left = 15, top = 8, bottom = 8, {
                    widget = wibox.layout.fixed.horizontal,
                    volume,
                    mem,
                    cpu,
                    battery,
                    {
                        widget = wibox.container.margin,
                        left = 15,
                        current_screen.systray,
                    },
                },
            },
        },
        x = current_screen.geometry.width / 2 - 350,
        y = current_screen.geometry.height - 40 - 10,
        width = 700, height = 40,
    })

    current_screen.wibar.third = wibar_section(current_screen, {
        widget = {
            widget = wibox.container.margin,
            left = 15, top = 8, bottom = 8, {
                widget = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    right = 5,
                    {
                        widget = wibox.widget.imagebox,
                        image = beautiful.calendar,
                        resize = true,
                    }
                },
                date,
                {
                    widget = wibox.container.margin,
                    left = 10, right = 5,
                    {
                        widget = wibox.widget.imagebox,
                        image = beautiful.clock,
                        resize = true,
                    }
                },
                time,
            },
        },
        x = current_screen.geometry.width - 240 - 10,
        y = current_screen.geometry.height - 40 - 10,
        width = 240, height = 40,
    })

    current_screen.cal = awful.widget.calendar_popup.month({
        margin = 0, screen = current_screen,
        spacing = 10, week_numbers = true,
        style_focus = { fg_color = beautiful.fg_normal, border_width = 1 },
        style_weekday = { border_width = 0, bg_color = "#00000000" },
        style_normal = { border_width = 0, bg_color = "#00000000" },
        style_header = { border_width = 0, bg_color = "#00000000" },
        style_month  = { padding = 25 },
        style_weeknumber  = {
            fg_color = beautiful.fg_minimize,
            bg_color = beautiful.fg_normal,
            border_width = 0,
        },
    })
    current_screen.cal:attach(current_screen.wibar.third.widget, "cc")

    current_screen.toggle_wibar = function ()
        for _, section in pairs(current_screen.wibar) do
            section.visible = not section.visible
        end
    end

    current_screen.disable_wibar = function ()
        for _, section in pairs(current_screen.wibar) do
            section.visible = false
        end
    end

    current_screen.detect = gears.timer {
        timeout = 1.25,
        callback = function ()
            if (mouse.screen ~= current_screen) or
                (mouse.coords().y < current_screen.geometry.y + current_screen.geometry.height - 75)
            then
                current_screen.disable_wibar()
                current_screen.detect:stop()
            end
        end
    }

    current_screen.enable_wibar = function ()
        for _, section in pairs(current_screen.wibar) do
            section.visible = true
            systray.set_screen(current_screen)
            current_screen.detect:start()
        end
    end

    current_screen.activation_zone = wibox ({
        x = current_screen.geometry.x, y = current_screen.geometry.y + current_screen.geometry.height - 2,
        opacity = 0.0, width = current_screen.geometry.width, height = 2,
        screen = current_screen, input_passthrough = false, visible = true,
        ontop = false, type = "dock",
    })

    current_screen.activation_zone:connect_signal("mouse::enter", function ()
        current_screen.temp_timer:stop()
        current_screen.enable_wibar()
    end)

    current_screen.disable_wibar()

    current_screen.temp_timer = gears.timer {
        timeout = 2,
        call_now = false,
        autostart = false,
        callback = function ()
            current_screen.disable_wibar()
            current_screen.temp_timer:stop()
        end
    }

    current_screen.temp_show = function (section)
        if not current_screen.wibar[section].visible then
            current_screen.wibar[section].visible = true
            current_screen.temp_timer:start()
        else
            current_screen.temp_timer:again()
        end
    end
end)

-- Temporarily show tag indicator when changing tags
screen.connect_signal("tag::history::update", function (current_screen)
    current_screen.temp_show("first")
end)

-- Temporarily show layout indicator when changing layout
-- Note: Why isn't this signal in the wiki :(
tag.connect_signal("property::layout", function (current_tag)
    current_tag.screen.temp_show("first")
end)

-- Temporarily show layout indicator when there is an urgent tag
tag.connect_signal("property::urgent", function (current_tag)
    current_tag.screen.temp_show("first")
end)

-- ==================
-- Bindings/Shortcuts
-- ==================

-- Determine what mouse buttons do on root window
root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu_root:toggle() end),
    awful.button({ }, 4, function ()
        awful.tag.viewnext()
        awful.screen.focused().temp_show("first")
    end
    ),
    awful.button({ }, 5, function ()
        awful.tag.viewprev()
        awful.screen.focused().temp_show("first")
    end)
))

local function global_next_client(direction)
    local next_client = awful.client.next(direction)
    local clients = awful.screen.focused():get_clients(false)

    if direction == 1 and next_client == clients[1] then
        awful.screen.focus_relative(direction)
        clients = awful.screen.focused():get_clients(false)
        client.focus = clients[1]
    elseif direction == -1 and next_client == clients[#clients] then
        awful.screen.focus_relative(direction)
        clients = awful.screen.focused():get_clients(false)
        client.focus = clients[#clients]
    else
        client.focus = next_client
    end

    if client.focus then
       client.focus:raise()
    end
end

-- Global Keys
local globalkeys = gears.table.join(
    -- Audio Controls
    awful.key(
        {}, "XF86AudioMute",
        function () awful.spawn("pactl set-sink-mute 0 toggle") end,
        { description = "toggle mute", group = "Audio" }
    ),
    awful.key(
        {}, "XF86AudioRaiseVolume",
        function () awful.spawn("pactl set-sink-volume 0 +10%") end,
        { description = "raise volume", group = "Audio" }
    ),
    awful.key(
        {}, "XF86AudioLowerVolume",
        function () awful.spawn("pactl set-sink-volume 0 -10%") end,
        { description = "lower volume", group = "Audio" }
    ),

    -- Awesome Controls
    awful.key(
        { user.modkey }, "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "Awesome" }
    ),
    awful.key(
        { user.modkey }, "w",
        function () menu_root:show() end,
        { description = "show main menu", group = "Awesome" }
    ),
    awful.key(
        { user.modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "Awesome" }
    ),
    awful.key(
        { user.modkey }, ",",
        function ()
            screen.primary.systray.visible =
                not screen.primary.systray.visible
        end,
        { description = "toggle system tray", group = "Awesome" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "Awesome" }
    ),

    -- Tag Controls
    awful.key(
        { user.modkey }, "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "Tag"  }
    ),
    awful.key(
        { user.modkey }, "Right",
        awful.tag.viewnext,
        { description = "view next", group = "Tag"  }
    ),
    awful.key(
        { user.modkey }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "Tag"  }
    ),

    -- Client/Layout Controls
    awful.key({ user.modkey }, "j",
        function () global_next_client(-1) end,
        { description = "focus next by index", group = "Client" }
    ),
    awful.key({ user.modkey }, "k",
        function () global_next_client(1) end,
        { description = "focus previous by index", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "f",
        function ()
            current_tag = awful.screen.focused().selected_tag
            if current_tag.gap == 0 then
                current_tag.gap = 8
            else
                current_tag.gap = 0
            end
        end,
        { description = "toggle focus mode", group = "Layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "j",
        function () awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "k",
        function () awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "l",
        function () awful.tag.incmwfact(0.025) end,
        { description = "increase master width factor", group = "Layout" }
    ),
    awful.key(
        { user.modkey }, "h",
        function () awful.tag.incmwfact(-0.025) end,
        { description = "decrease master width factor", group = "Layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "h",
        function () awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "Layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "l",
        function () awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "Layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "h",
        function () awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "Layout" }
    ),
    awful.key(
        { user.modkey, "Control" }, "l",
        function () awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "Layout" }
    ),
    awful.key(
        { user.modkey }, "space",
        function () awful.layout.inc(1) end,
        { description = "select next", group = "Layout" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "space",
        function () awful.layout.inc(-1) end,
        { description = "select previous", group = "Layout" }
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
        { description = "restore minimized", group = "Client"}
    ),

    -- Screen Controls
    awful.key(
        { user.modkey, "Control" }, "p",
        function () awful.spawn("killall picom") end,
        { description = "kill picom", group = "Screen" }
    ),
    -- awful.key(
    --     { user.modkey, "Control" }, "j",
    --     function () awful.screen.focus_relative(1) end,
    --     { description = "focus the next screen", group = "Screen" }
    -- ),
    -- awful.key(
    --     { user.modkey, "Control" }, "k",
    --     function () awful.screen.focus_relative(-1) end,
    --     { description = "focus the previous screen", group = "Screen" }
    -- ),
    awful.key(
        {}, "XF86PowerOff",
        function () awful.spawn("xset dpms force off") end,
        { description = "turn off the display", group = "Screen" }
    ),
    awful.key({}, "XF86Explorer",
        function () awful.spawn("pkill -USR1 '^redshift$'") end,
        { description = "toggle redshift (FN+F11)", group = "Screen" }
    ),

    -- Applications
    awful.key(
        { user.modkey }, "Return",
        function () awful.spawn(user.terminal) end,
        { description = "open a terminal", group = "Applications" }
    ),
    awful.key(
        { user.modkey }, "b", function () awful.spawn(user.browser) end,
        { description = "open browser", group = "Applications" }
    ),
    awful.key(
        { user.modkey }, "d", function () awful.spawn("discord") end,
        { description = "open discord", group = "Applications" }
    ),
    awful.key(
        {}, "Print", function () awful.spawn("flameshot gui") end,
        { description = "open flameshot (Screnshot tool)", group = "Applications" }
    ),

    -- Launcher (Rofi Prompts)
    awful.key(
        { user.modkey }, "r",
        function () awful.spawn("rofi -show run") end,
        { description = "show the run menu", group = "Launcher" }
    ),
    awful.key(
        { user.modkey }, "`",
        function () awful.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard") end,
        { description = "show the clipboard manager", group = "Launcher" }
    ),
    awful.key(
        { user.modkey }, "p",
        function () awful.spawn("rofi -show drun -show-icons true") end,
        { description = "show the application launcher", group = "Launcher" }
    ),
    awful.key(
        { user.modkey }, ".",
        function () awful.spawn("rofimoji")  end,
        { description = "show emoji selector", group = "Launcher" }
    ),
    awful.key(
        { user.modkey }, "Tab",
        function () awful.spawn("rofi -show window") end,
        { description = "open window list", group = "Launcher" }
    ),
    
    -- System Controls
    awful.key(
        { "Control", user.modkey }, "Delete",
        function () awful.spawn("reboot") end,
        { description = "reboot computer", group = "System" }
    )
)

local clientkeys = gears.table.join(
    awful.key(
        { user.modkey, "Shift" }, "f",
        function (c)
            c.floating = not c.floating
            c:raise()
        end,
        { description = "toggle floating", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "c",
        function (c) c:kill() end,
        { description = "close", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "o",
        function (c) c:move_to_screen() end,
        { description = "move to screen", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "t",
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "Client" }
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
                local current_screen = awful.screen.focused()
                local tag = current_screen.tags[i]
                if tag then
                   tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "Tag" }
        ),

        -- Toggle tag display.
        awful.key(
            { user.modkey, "Control" }, "#" .. i + 9,
            function ()
                local current_screen = awful.screen.focused()
                local tag = current_screen.tags[i]
                if tag then
                   awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "Tag" }
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
            {description = "move focused client to tag #"..i, group = "Tag" }
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
            {description = "toggle focused client on tag #" .. i, group = "Tag" }
        )
    )
end

local clientbuttons = gears.table.join(
    awful.button(
        { }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end
    ),
    awful.button(
        { user.modkey }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        { user.modkey }, 3,
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
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

    -- Enable titlebars to normal clients
    {
        rule_any = { type = { "normal" } },
        except_any = { class = { "Steam" } },
        properties = { titlebars_enabled = true }
    },

    -- Floating clients.
    {   
        rule_any = {
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true } },

    -- Exceptions

    { rule = { class = "origin.exe" },
    properties = { titlebars_enabled = false, floating = true } },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
    end

    -- Disable any type of maximization
    c.maximized = false
    c.maximized_horizontal = false
    c.maximized_vertical = false
end)

-- Enable titlebar
client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {
        position = "top",
        size = beautiful.get_font_height(beautiful.font) * 1.3
    }):setup {
        { -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            margins = 3, left = 5,
            widget = wibox.container.margin
        },
        { -- Middle
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                spacing = 5,
                layout = wibox.layout.fixed.horizontal
            },
            margins = 3,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- Sloppy/Lazy Focus (Focus follows mouse)
client.connect_signal("mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

-- Remove rounded corners if in fullscreen
client.connect_signal("property::geometry", function(c)
    if c.fullscreen or c.maximized then
        c.shape = gears.shape.rectangle
    else
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
    end
end)

-- ===============
-- Autostart Setup
-- ===============

awful.spawn("libinput-gestures-setup start")

-- Oh my god pgrep is so good
awful.spawn.with_shell("pgrep solaar || solaar")
awful.spawn.with_shell("pgrep picom || picom -b")
awful.spawn.with_shell("pgrep discord || discord")
awful.spawn.with_shell("pgrep redshift || redshift-gtk")
awful.spawn.with_shell("pgrep qbittorrent || qbittorrent")
awful.spawn.with_shell("pgrep greenclip || greenclip daemon")

-- awful.spawn.with_shell("pgrep steam || steam -silent")

-- Make sure Caps Lock is disabled and remapped
awful.spawn.with_shell(
    "(xset -q | grep 'Caps Lock:[ ]\\+on' -c) " ..
    "&& xdotool key Caps_Lock; " ..
    "setxkbmap -option caps:escape"
)

