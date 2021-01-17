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

-- Notification libraries
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Pre-made widget library
local lain = require("lain")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- TODO: Fix issue on why it keeps displaying Tmux only
-- require("awful.hotkeys_popup.keys")

-- Shortcuts
local alt = "Mod1"
local super = "Mod4"
local config_dir = gears.filesystem.get_configuration_dir()
local script_path = config_dir .. "scripts/"

-- ============
-- User options
-- ============

user = {
    theme = "rocky_skies",
    modkey = super,
    apps = {
        torrent = "qbittorrent",
        files = "thunar",
        browser = "google-chrome-stable",
        terminal = "kitty",
        editor = os.getenv("EDITOR") or "vim",
        music = "LD_PRELOAD=/usr/local/lib/spotify-adblock.so spotify-tray",
        communication = "discord",
    },
    startup = {
        solaar = "",
        copyq = "",
        discord = "",
        picom = " -b",
        udiskie = " -t",
        redshift = "-gtk",
        qbittorrent = "",
        libinput = "-gestures-setup start",
    },
}

-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
}

-- Theme Initialization
beautiful.init(
    config_dir .. "themes/" ..
    user.theme .. "/theme.lua"
)

-- ==============
-- Error handling
-- ==============

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })

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
    { "Docs", user.apps.browser .. " /usr/share/doc/awesome/doc/index.html" },
    { "Config", user.apps.terminal .. " " .. user.apps.editor .. " " .. awesome.conffile },
    { "Restart", awesome.restart },
    { "Quit", awesome.quit },
}

local menu_apps = {
    { "Browser", user.apps.browser },
    { "Torrents", user.apps.torrent },
    { "Obsidian", "obsidian" },
    { "Communication", user.apps.communication },
    { "Music",  function ()
        awful.spawn.with_shell(user.apps.music .. " -m")
    end },
    { "Steam",  "steam-runtime" },
    -- TODO: Find out why rofi doesn't launch consistently
    { "Launcher", function ()
        awful.spawn("rofi -show drun -show-icons true")
    end },
}

local menu_root = awful.menu({ items = {
    { "Awesome", menu_awesome, beautiful.awesome_icon },
    { "Apps", menu_apps },
    { "Files", user.apps.files },
    { "Terminal", user.apps.terminal },
}})

-- TODO: Figure out why this doesn't work
menu_root.shape = beautiful.shape

awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = menu_root
})

-- ===============
-- Wallpaper Setup
-- ===============

local set_wallpaper = function (s)
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
if beautiful.dynamic_wallpaper then
    local bg_path = config_dir ..
        "themes/" .. user.theme .. "/background.mp4"
    awful.spawn(script_path .. "setlivewallpaper.sh " .. bg_path)
end

-- ==================
-- Wibar/Widget Setup
-- ==================

-- Date/Time
local date = wibox.widget.textclock("%a, %b.%e")
local time = wibox.widget.textclock("%H:%M")
date.align = "center"
time.align = "center"

-- Helper function that facilitates shared tag switching
local switch_to_tag = function (tag_target)
    local screen_focus = awful.screen.focused()
    local tag_other = screen_focus.selected_tag
    if
        tag_target.screen ~= screen_focus and
        tag_target.screen.selected_tag == tag_target
    then
        tag_other.screen = tag_target.screen
        tag_other:view_only()
    end
    tag_target.screen = screen_focus
    tag_target.name = screen_focus.index
    tag_target:view_only()
end

-- Helper function to go to next/prev tag
local view_tag_dir = function (tag_current, direction)
    local tags = root.tags()
    local idx
    for i, t in pairs(tags) do
        if t == tag_current then
            idx = i + direction
            break
        end
    end
    local tag_target = tags[gears.math.cycle(#tags, idx)]
    -- Skip tags that are already shown
    for s in screen do
        if tag_target == s.selected_tag then
            idx = idx + direction
            tag_target = tags[gears.math.cycle(#tags, idx)]
        end
    end
    switch_to_tag(tag_target)
end

-- Tag List
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, switch_to_tag),
    awful.button({ user.modkey }, 1,
        function (t)
            for _, c in pairs(awful.screen.focused():get_clients()) do
                c:move_to_tag(t)
            end
        end
    ),
    awful.button({ }, 3,
        function (t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    -- awful.button({ }, 3, awful.tag.viewtoggle),
    -- awful.button({ user.modkey }, 3,
    --     function (t)
    --         if client.focus then
    --             client.focus:toggle_tag(t)
    --         end
    --     end
    -- ),
    awful.button({ }, 4,
        function (t) view_tag_dir(t.screen.selected_tag, 1) end
    ),
    awful.button({ }, 5,
        function (t) view_tag_dir(t.screen.selected_tag, -1) end
    )
)

-- Task List
local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({ }, 3, function ()
      awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
    end)
)

-- PulseAudio Volume Controller
local volume_text = lain.widget.pulse {
    settings = function ()
        widget:set_markup(
            (volume_now.muted == "yes") and "Mute" or volume_now.right .. "%"
        )
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
    awful.button({ }, 1, function () awful.spawn("pavucontrol") end),
    awful.button({ }, 3, function ()
        os.execute(
            string.format("pactl set-sink-mute %s toggle", volume_text.device)
        )
        volume_text.update()
    end),
    awful.button({ }, 4, function ()
        os.execute(
            string.format("pactl set-sink-volume %s +1%%", volume_text.device)
        )
        volume_text.update()
    end),
    awful.button({ }, 5, function ()
        os.execute(
            string.format("pactl set-sink-volume %s -1%%", volume_text.device)
        )
        volume_text.update()
    end)
))

-- Battery Indicator
local battery_text = lain.widget.bat({
    settings = function ()
        widget:set_markup(
            ((bat_now.perc == "N/A") and "?" or bat_now.perc) .. "%"
        )
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
        widget:set_markup(
            cpu_now.usage .. "%"
        )
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

cpu:buttons(awful.util.table.join(
    awful.button({ }, 1, function ()
        awful.spawn(user.apps.terminal .. " htop")
    end)
))

-- Memory Indicator
local mem_text = lain.widget.mem({
    settings = function ()
        widget:set_markup(mem_now.used / 1000 .. "GiB")
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

mem:buttons(awful.util.table.join(
    awful.button({ }, 1, function ()
        awful.spawn(user.apps.terminal .. " htop")
    end)
))

-- Creates floating wibar sections
local wibar_section = function (s, args)
    local section = wibox({
        screen = s,
        height = args.height, width = args.width,
        border_width = beautiful.border_width,
        border_color = beautiful.bg_focus,
        x = s.geometry.x + args.x,
        y = s.geometry.y + args.y,
        bg = beautiful.bg_normal, visible = true,
        ontop = true, shape = gears.shape.rectangle,
        input_passthrough = false, type = "dock",
    })

    -- Border Radius
    section.shape = beautiful.shape

    -- Uncomment to change workspace area
    -- section:struts({ top = 0, bottom = 45 })

    section:setup {
        layout = wibox.layout.fixed.horizontal,
        args.widget
    }

    -- Place to store custom functions
    section.custom = { }

    -- Custom timer to show a part temporarily
    section.custom.temp_timer = gears.timer {
        timeout = 3,
        call_now = false,
        autostart = false,
        callback = function ()
            section.visible = false
            section.custom.temp_timer:stop()
        end
    }

    section.custom.temp_show = function ()
        if not section.visible then
            section.visible = true
            section.custom.temp_timer:start()
        else
            section.custom.temp_timer:again()
        end
    end

    return section
end

-- Systray
local systray = wibox.widget.systray()
systray.visible = true
systray.forced_height = 25

-- Add a widgets to each screen
awful.screen.connect_for_each_screen(function (s)
    set_wallpaper(s)

    s.systray = systray

    -- Imagebox which contains an icon indicating current layout
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    if s.index == 1 then
        awful.tag(
            { " ", " ", " ", " ", " ", " ", " ", " ", " " },
            s, awful.layout.layouts[1]
        )
    end

    -- Make sure each screen has a tag and it is in focus
    local all_tags = root.tags()
    all_tags[gears.math.cycle(#all_tags, s.index)].screen = s.index
    all_tags[s.index].name = s.index
    all_tags[s.index]:view_only()

    local colors = { beautiful.xrdb.color6, beautiful.xrdb.color5 }
    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        source = root.tags,
        style = {
            spacing = beautiful.useless_gap,
        },
        buttons = taglist_buttons,
        widget_template = {
            { markup = "", widget = wibox.widget.textbox },
            forced_width = 20,
            shape = gears.shape.circle,
            widget = wibox.container.background,
            update_callback = function (self, t, _index, _tags)
                if t.screen.selected_tag == t then
                    self.bg = colors[t.screen.index]
                elseif #t:clients() > 0 then
                    self.bg = beautiful.fg_normal
                else
                    self.bg = beautiful.bg_minimize
                end
            end,
        },
    }

    -- Create a tasklist widget
    s.tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            shape = beautiful.shape,
            bg_focus = beautiful.bg_normal,
            spacing = beautiful.useless_gap
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 1,
                        widget = wibox.container.margin,
                    },
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                -- Uneven margins to account for icon opacity
                left = 10,
                right = 15,
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    }

    -- Create a Wibar
    s.wibar = { }

    s.wibar[1] = wibar_section(s, {
        widget = {
            widget = wibox.container.margin,
            left = beautiful.useless_gap,
            {
                layout = wibox.layout.fixed.horizontal,
                {
                        widget = wibox.container.margin,
                        forced_width = 40,
                        forced_height = 40,
                        margins = beautiful.useless_gap,
                        s.layoutbox,
                },
                s.taglist,
            },
        },
        x = beautiful.useless_gap * 2,
        y = s.geometry.height - 40 - 2 * (beautiful.useless_gap + beautiful.border_width),
        width = #root.tags() * (20 + beautiful.useless_gap) + 40 + 2 * beautiful.useless_gap,
        height = 40,
    })

    s.wibar[2] = wibar_section(s, {
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
                        s.systray,
                    },
                },
            },
        },
        x = s.geometry.width / 2 - 350,
        y = s.geometry.height - 40 - 2 * (beautiful.useless_gap + beautiful.border_width),
        width = 700, height = 40,
    })

    s.wibar[3] = wibar_section(s, {
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
        x = s.geometry.width - 240 - 2 * (beautiful.useless_gap + beautiful.border_width),
        y = s.geometry.height - 40 - 2 * (beautiful.useless_gap + beautiful.border_width),
        width = 240, height = 40,
    })

    s.cal = awful.widget.calendar_popup.month({
        margin = 0, screen = s,
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
    s.cal:attach(s.wibar[3].widget, "cc")

    s.disable_wibar = function ()
        for _, section in pairs(s.wibar) do
            section.visible = false
        end
    end

    s.detect = gears.timer {
        timeout = 0.35,
        callback = function ()
            if (mouse.screen ~= s) or
                (mouse.coords().y < s.geometry.y + s.geometry.height - 75)
            then
                s.disable_wibar()
                s.detect:stop()
            end
        end
    }

    s.enable_wibar = function ()
        for _, section in pairs(s.wibar) do
            section.visible = true
            systray.set_screen(s)
            if not s.detect.started then
                s.detect:start()
            end
        end
    end

    s.toggle_wibar = function ()
        local visible = true
        for i, section in ipairs(s.wibar) do
            if i == 1 then
                visible = not section.visible
            end
            section.visible = visible
            systray.set_screen(s)
        end
    end

    s.activation_zone = wibox ({
        x = s.geometry.x, y = s.geometry.y + s.geometry.height - 1,
        opacity = 0.0, width = s.geometry.width, height = 1,
        screen = s, input_passthrough = false, visible = true,
        ontop = true, type = "dock",
    })

    s.activation_zone:connect_signal("mouse::enter", function ()
        for _, section in pairs(s.wibar) do
            if section.custom.temp_timer.started then
                section.custom.temp_timer:stop()
            end
        end
        s.enable_wibar()
    end)

    s.disable_wibar()

    s.temp_show = function (section)
        s.wibar[section].custom.temp_show()
    end

    -- Taskbar
    s.taskbar_activation = wibox ({
        x = s.geometry.x + s.geometry.width / 3, y = s.geometry.y,
        opacity = 0.0, width = s.geometry.width / 3, height = 1,
        screen = s, input_passthrough = false, visible = true,
        ontop = true, type = "dock",
    })

    s.taskbar = wibox({
        screen = s, width = s.geometry.width - 4 * beautiful.useless_gap,
        height = beautiful.get_font_height(beautiful.font) * 1.3,
        x = s.geometry.x + beautiful.useless_gap * 2,
        y = s.geometry.y + beautiful.useless_gap * 2,
        bg = "#00000000", visible = true, ontop = true,
        input_passthrough = false, type = "dock",
        shape = beautiful.shape,
    })

    s.disable_taskbar = function ()
        s.taskbar.visible = false
    end

    s.taskbar_detect = gears.timer {
        timeout = 0.25,
        callback = function ()
            if (mouse.screen ~= s) or
                (mouse.coords().y > s.geometry.y + 40)
            then
                s.disable_taskbar()
                s.taskbar_detect:stop()
            end
        end
    }

    s.enable_taskbar = function ()
        s.taskbar.visible = true
        if not s.taskbar_detect.started then
            s.taskbar_detect:start()
        end
    end


    s.taskbar:setup {
            widget = wibox.container.place,
            halign = "center",
            s.tasklist,
    }

    s.taskbar_activation:connect_signal("mouse::enter", function ()
        s.enable_taskbar()
    end)

    s.disable_taskbar()
end)

-- Temporarily show tag indicator and update tag names
screen.connect_signal("tag::history::update", function (s)
    s.temp_show(1)
    for _, t in pairs(root.tags()) do
        if t.screen.selected_tag == t then
            t.name = t.screen.index
        else
            t.name = " "
        end
    end
end)

-- Temporarily show layout indicator when changing layout
-- Note: Why isn't this signal in the wiki :(
tag.connect_signal("property::layout", function (t)
    t.screen.temp_show(1)
end)

-- Focus urgent tag
tag.connect_signal("property::urgent", function (t)
    switch_to_tag(t)
end)

-- ==================
-- Bindings/Shortcuts
-- ==================


local tb_wrapper = function (c)
    local titlebar = awful.titlebar(c, {
        position = "top",
        size = beautiful.get_font_height(beautiful.font) * 1.3,
        bg_normal = beautiful.bg_normal .. beautiful.transparency,
        bg_focus = beautiful.bg_normal .. beautiful.transparency,
        fg_focus = beautiful.fg_normal,
    })

    titlebar.hide = function () awful.titlebar.hide(c) end

    if titlebar.widget then
        titlebar.show = function () awful.titlebar.show(c) end
    else
        titlebar.show = function () end
        titlebar.hide()
    end

    if c.first_tag and c.first_tag.gap == 0 then
        titlebar.hide()
    end

    return titlebar
end

-- Determine what mouse buttons do on root window
root.buttons(gears.table.join(
    awful.button({ }, 3, function () menu_root:toggle() end),
    awful.button({ }, 4, function ()
        view_tag_dir(awful.screen.focused().selected_tag, 1)
    end
    ),
    awful.button({ }, 5, function ()
        view_tag_dir(awful.screen.focused().selected_tag, -1)
    end)
))

-- Helper function to globally switch across screens
local global_next_client = function (direction)
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
    elseif #clients <= 0 then
        awful.screen.focus_relative(direction)
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
        { }, "XF86AudioMute",
        function () awful.spawn("pactl set-sink-mute 0 toggle") end,
        { description = "toggle mute", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioRaiseVolume",
        function () awful.spawn("pactl set-sink-volume 0 +10%") end,
        { description = "raise volume", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioLowerVolume",
        function () awful.spawn("pactl set-sink-volume 0 -10%") end,
        { description = "lower volume", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioPlay",
        function () awful.spawn("playerctl --player=spotify play-pause") end,
        { description = "play/pause Spotify", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioPause",
        function () awful.spawn("playerctl --player=spotify play-pause") end,
        { description = "play/pause Spotify", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioStop",
        function () awful.spawn("playerctl --player=spotify pause") end,
        { description = "pause Spotify", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioNext",
        function () awful.spawn("playerctl --player=spotify next") end,
        { description = "go to next track in Spotify", group = "Audio" }
    ),
    awful.key(
        { }, "XF86AudioPrev",
        function () awful.spawn("playerctl --player=spotify previous") end,
        { description = "go to previous track in Spotify", group = "Audio" }
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
        { user.modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "Awesome" }
    ),

    -- Tag Controls
    awful.key(
        { user.modkey }, "Left",
        function ()
            view_tag_dir(awful.screen.focused().selected_tag, -1)
        end,
        { description = "view previous", group = "Tag"  }
    ),
    awful.key(
        { user.modkey }, "Right",
        function ()
            view_tag_dir(awful.screen.focused().selected_tag, 1)
        end,
        { description = "view next", group = "Tag"  }
    ),

    -- Client/Layout Controls
    awful.key({ user.modkey }, "j",
        function () global_next_client(1) end,
        { description = "focus next by index", group = "Client" }
    ),
    awful.key({ user.modkey }, "k",
        function () global_next_client(-1) end,
        { description = "focus previous by index", group = "Client" }
    ),
    -- TODO: Make alt-tabbing better
    awful.key({ alt }, "Tab",
        function () global_next_client(1) end,
        { description = "focus next by index", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                  "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "Client"}
    ),
    -- TODO: Find out how to make this more robust for shared tags
    awful.key(
        { user.modkey, "Shift" }, "j",
        function ()
            if client.focus then
                local clients = client.focus.screen:get_clients(false)
                if client.focus == clients[#clients] then
                    client.focus:move_to_screen(client.focus.screen.index + 1)
                else
                    awful.client.swap.byidx(1)
                end
            end
        end,
        { description = "swap with next client", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Shift" }, "k",
        function ()
            if client.focus then
                local clients = client.focus.screen:get_clients(false)
                if client.focus == clients[1] then
                    client.focus:move_to_screen(client.focus.screen.index - 1)
                else
                    awful.client.swap.byidx(-1)
                end
            end
        end,
        { description = "swap with previous client", group = "Client" }
    ),
    awful.key(
        { user.modkey, "Control" }, "f",
        function ()
            local t = awful.screen.focused().selected_tag
            if t.gap == 0 then
                t.gap = beautiful.useless_gap
                for _, c in pairs(t:clients()) do
                    tb_wrapper(c).show()
                end
            else
                t.gap = 0
                for _, c in pairs(t:clients()) do
                    tb_wrapper(c).hide()
                end
            end
        end,
        { description = "toggle focus mode", group = "Layout" }
    ),
    awful.key(
        { user.modkey }, "l",
        function () awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "Layout" }
    ),
    awful.key(
        { user.modkey }, "h",
        function () awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "Layout" }
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

    -- Screen Controls
    awful.key(
        { user.modkey }, ",",
        function ()
            awful.screen.focused().toggle_wibar()
        end,
        { description = "show help", group = "Awesome" }
    ),
    awful.key(
        { user.modkey, "Control" }, "p",
        function () awful.spawn("killall picom") end,
        { description = "kill picom", group = "Screen" }
    ),
    awful.key(
        { user.modkey, "Control" }, "j",
        function () awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "Screen" }
    ),
    awful.key(
        { user.modkey, "Control" }, "k",
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "Screen" }
    ),
    awful.key(
        { }, "XF86PowerOff",
        function ()
            -- Makes sure Steam is shutdown so it doesn't wake screen
            awful.spawn.with_shell("pgrep steam && steam -shutdown")
            -- Turns off and locks
            awful.spawn.with_shell("xset dpms force off && slock")
        end,
        { description = "turn off the display", group = "Screen" }
    ),
    awful.key(
        { }, "XF86Explorer",
        function () awful.spawn("pkill -USR1 '^redshift$'") end,
        { description = "toggle redshift (FN+F11)", group = "Screen" }
    ),

    -- Applications
    awful.key(
        { alt }, "F4",
        function () awful.spawn("xkill") end,
        { description = "kill and app", group = "Applications" }
    ),
    awful.key(
        { user.modkey }, "Return",
        function () awful.spawn(user.apps.terminal) end,
        { description = "open a terminal", group = "Applications" }
    ),
    awful.key(
        { user.modkey }, "b", function () awful.spawn(user.apps.browser) end,
        { description = "open browser", group = "Applications" }
    ),
    awful.key(
        { user.modkey }, "d", function () awful.spawn(user.apps.communication) end,
        { description = "open communications app", group = "Applications" }
    ),
    awful.key(
        { user.modkey }, "m", function () awful.spawn.with_shell(user.apps.music .. " -tm") end,
        { description = "open music app", group = "Applications" }
    ),
    awful.key(
        { }, "Print", function () awful.spawn("flameshot gui") end,
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
        function () awful.spawn.with_shell("~/.local/bin/rofi-copyq") end,
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
        { user.modkey }, "o",
        function (c) c:move_to_screen() end,
        { description = "move to next screen", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "t",
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "Client" }
    ),
    awful.key(
        { user.modkey }, "n",
        function (c)
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
                local t = root.tags()[i]
                switch_to_tag(t)
            end,
            { description = "view tag #"..i, group = "Tag" }
        ),

        -- Move client to tag.
        awful.key(
            { user.modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    client.focus:move_to_tag(root.tags()[i])
                end
            end,
            { description = "move focused client to tag #"..i, group = "Tag" }
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

-- Rules to apply to new clients
awful.rules.rules = {
    -- All clients
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen,
            maximized = false,
        }
    },

    -- Enable titlebars to normal clients
    {
        rule_any = {
            type = { "normal", "dialogue" }
        },
        except_any = {
            class = {
                "Steam", "Lutris",
                "origin.exe", "osu!",
                "Spotify", "csgo_linux64",
            }
        },
        properties = { titlebars_enabled = true }
    },

    -- On Top clients.
    {
        rule_any = {
            class = { "Thunar" },
        },
        properties = { ontop = true }
    },

    -- Floating clients.
    {
        rule_any = {
            role = {
              "pop-up", "dialogue",
            },
            class = { "Thunar", "imv", "copyq" },
        },
        properties = {
            floating = true,
            border_width = 2,
            border_color = beautiful.border_normal,
        }
    },

    -- Auto-fullscreen
    {
        rule_any = {
            class = {
              "csgo_linux64",
            }
        },
        properties = {
            floating = true,
            fullscreen = true,
        }
    },

    -- Exceptions
    {
        rule = { class = "origin.exe" },
        properties = { floating = true }
    },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable
            -- after screen count changes.
            awful.placement.no_offscreen(c)
    end
end)

-- Enable titlebar
client.connect_signal("request::titlebars", function (c)
    local buttons = gears.table.join(
        awful.button({ }, 1, function ()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function ()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    local titlebar = awful.titlebar(c, {
        size = beautiful.get_font_height(beautiful.font) * 1.3,
        bg_normal = beautiful.bg_normal .. beautiful.transparency,
        bg_focus = beautiful.bg_normal .. beautiful.transparency,
        fg_focus = beautiful.fg_normal,
    })

    titlebar:setup {
        {
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            margins = 2, left = beautiful.useless_gap,
            widget = wibox.container.margin
        },
        {
            {
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
            {
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.closebutton(c),
                spacing = beautiful.useless_gap,
                layout = wibox.layout.fixed.horizontal
            },
            margins = 3,
            right = beautiful.useless_gap,
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Sloppy/Lazy Focus (Focus follows mouse)
client.connect_signal("mouse::enter", function (c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function (c)
    c.border_color = beautiful.border_focus
    local titlebar = tb_wrapper(c)
    if titlebar.widget then
        titlebar.widget.children[2].opacity = 1
        titlebar.widget.children[3].opacity = 1
    end
end)

client.connect_signal("unfocus", function (c)
    c.border_color = beautiful.border_normal
    local titlebar = tb_wrapper(c)
    if titlebar.widget then
        titlebar.widget.children[2].opacity = 0
        titlebar.widget.children[3].opacity = 0
    end
end)

local is_fullscreen = function (c)
	local fills_screen = function ()
		local wa = c.screen.workarea
		local cg = c:geometry()
		return wa.x == cg.x and wa.y == cg.y and wa.width == cg.width and wa.height == cg.height
	end
	return c.maximized or fills_screen() or c.fullscreen
end

-- Remove rounded corners if in fullscreen
client.connect_signal("property::geometry", function (c)
    if
        is_fullscreen(c) or
        (c.first_tag and c.first_tag.gap == 0)
    then
        c.shape = gears.shape.rectangle

        -- Prevent fullscreen in focus mode
        if c.first_tag and c.first_tag.gap == 0 then
            c.fullscreen = false
        end

        -- Prevent notifications
        naughty.suspend()
    else
        c.shape = beautiful.shape

        -- Resume notifications
        naughty.resume()
    end
end)

-- Prevent maximized screens
local disable_maximize = function (c)
    c.maximized = false
    c.maximized_horizontal = false
    c.maximized_vertical = false
end

client.connect_signal("property::maximized", disable_maximize)

client.connect_signal("property::maximized_horizontal", disable_maximize)

client.connect_signal("property::maximized_vertical", disable_maximize)

-- ===============
-- Autostart Setup
-- ===============

-- Oh my god pgrep is so good
local launch = function (program, extra)
    awful.spawn.with_shell(
        "pgrep " .. program .. " || " .. program .. extra
    )
end

for program, extra in pairs(user.startup) do
    launch(program, extra)
end

-- Make sure Caps Lock is disabled and remapped
awful.spawn.with_shell(
    "(xset -q | grep 'Caps Lock:[ ]\\+on' -c) " ..
    "&& xdotool key Caps_Lock; " ..
    "setxkbmap -option caps:escape"
)

