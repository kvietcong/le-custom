--                   ___           ___           ___           ___
--       ___        /__/\         /  /\         /__/\         /  /\
--      /  /\       \  \:\       /  /:/_       |  |::\       /  /:/_
--     /  /:/        \__\:\     /  /:/ /\      |  |:|:\     /  /:/ /\
--    /  /:/     ___ /  /::\   /  /:/ /:/_   __|__|:|\:\   /  /:/ /:/_
--   /  /::\    /__/\  /:/\:\ /__/:/ /:/ /\ /__/::::| \:\ /__/:/ /:/ /\
--  /__/:/\:\   \  \:\/:/__\/ \  \:\/:/ /:/ \  \:\~~\__\/ \  \:\/:/ /:/
--  \__\/  \:\   \  \::/       \  \::/ /:/   \  \:\        \  \::/ /:/
--       \  \:\   \  \:\        \  \:\/:/     \  \:\        \  \:\/:/
--        \__\/    \  \:\        \  \::/       \  \:\        \  \::/
--                  \__\/         \__\/         \__\/         \__\/

--       ___       ___           ___
--      /\__\     /\__\         /\  \
--     /:/  /    /:/  /        /::\  \
--    /:/  /    /:/  /        /:/\:\  \
--   /:/  /    /:/  /  ___   /::\~\:\  \
--  /:/__/    /:/__/  /\__\ /:/\:\ \:\__\
--  \:\  \    \:\  \ /:/  / \/__\:\/:/  /
--   \:\  \    \:\  /:/  /       \::/  /
--    \:\  \    \:\/:/  /        /:/  /
--     \:\__\    \::/  /        /:/  /
--      \/__/     \/__/         \/__/


-- ==========================================================
-- ==========================================================
--
-- derpyasianpanda's Static Awesome Theme Based on Xresources
--
-- ==========================================================
-- ==========================================================


local theme_assets = require("beautiful.theme_assets")
local gears = require("gears")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local icon_dir = gfs.get_configuration_dir() .. "icons"
local default_theme_dir = gfs.get_themes_dir() .. "default"

local transparent = "#00000000"
local theme = {}

theme.wallpaper = gfs.get_configuration_dir() .. "themes/static/background.png"

theme.font          = "Monaco 10"

theme.bg_normal     = xrdb.color0 .. "CC"
theme.bg_focus      = xrdb.color6 .. "CC"
theme.bg_urgent     = xrdb.color5 .. "CC"
theme.bg_minimize   = xrdb.color8 .. "CC"

theme.fg_normal     = xrdb.color7
theme.fg_focus      = xrdb.color6
theme.fg_minimize   = xrdb.color8
theme.fg_urgent     = xrdb.color5

theme.border_radius = dpi(8)

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

theme.taglist_bg_occupied = theme.bg_minimize

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(0)
theme.border_normal = theme.bg_minimize
theme.border_focus  = theme.fg_focus
theme.screen_margin  = theme.useless_gap

theme.notification_border_width = theme.border_width
theme.notification_border_color = theme.bg_focus
theme.notification_margin = dpi(10)
theme.notification_spacing = dpi(10)

theme.menu_height = dpi(25)
theme.menu_width  = dpi(200)
theme.menu_font = theme.font
theme.menu_border_color = theme.bg_normal
theme.menu_bg_normal = theme.bg_normal:sub(1, -3) .. "66"
theme.menu_bg_focus = theme.bg_normal

theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_group_margin = dpi(10)
theme.hotkeys_modifiers_fg = theme.fg_focus
theme.hotkeys_border_color = theme.bg_focus
theme.hotkeys_shape = gears.shape.rounded_rect

theme.titlebar_bg_focus = theme.bg_minimize

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height * 2, theme.bg_urgent, theme.fg_normal
)

-- Titlebar Icons
theme.titlebar_close_button_normal = default_theme_dir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = default_theme_dir .. "/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = default_theme_dir .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = default_theme_dir .. "/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = default_theme_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = default_theme_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = default_theme_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = default_theme_dir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = default_theme_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = default_theme_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = default_theme_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = default_theme_dir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = default_theme_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = default_theme_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = default_theme_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = default_theme_dir .. "/titlebar/floating_focus_active.png"

-- Custom Icons
theme.calendar  = icon_dir .. "/le/calendar.png"
theme.clock     = icon_dir .. "/le/clock.png"
theme.cpu       = icon_dir .. "/le/cpu.png"
theme.search    = icon_dir .. "/le/search.png"
theme.settings  = icon_dir .. "/le/settings.png"
theme.restart   = icon_dir .. "/le/restart.png"
theme.lock      = icon_dir .. "/le/lock.png"
theme.shutdown  = icon_dir .. "/le/shutdown.png"
theme.menu      = icon_dir .. "/le/menu.png"
theme.support   = icon_dir .. "/le/support.png"
theme.speaker   = icon_dir .. "/le/speaker.png"
theme.mute      = icon_dir .. "/le/mute.png"
theme.battery   = icon_dir .. "/le/battery.png"
theme.candle    = icon_dir .. "/le/candle.png"
theme.ram       = icon_dir .. "/le/ram.png"

-- Default Layout Icons
theme.layout_fairh      = default_theme_dir .. "/layouts/fairhw.png"
theme.layout_fairv      = default_theme_dir .. "/layouts/fairvw.png"
theme.layout_floating   = default_theme_dir .. "/layouts/floatingw.png"
theme.layout_magnifier  = default_theme_dir .. "/layouts/magnifierw.png"
theme.layout_max        = default_theme_dir .. "/layouts/maxw.png"
theme.layout_fullscreen = default_theme_dir .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = default_theme_dir .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = default_theme_dir .. "/layouts/tileleftw.png"
theme.layout_tile       = default_theme_dir .. "/layouts/tilew.png"
theme.layout_tiletop    = default_theme_dir .. "/layouts/tiletopw.png"
theme.layout_spiral     = default_theme_dir .. "/layouts/spiralw.png"
theme.layout_dwindle    = default_theme_dir .. "/layouts/dwindlew.png"
theme.layout_cornernw   = default_theme_dir .. "/layouts/cornernww.png"
theme.layout_cornerne   = default_theme_dir .. "/layouts/cornernew.png"
theme.layout_cornersw   = default_theme_dir .. "/layouts/cornersww.png"
theme.layout_cornerse   = default_theme_dir .. "/layouts/cornersew.png"

-- Recolor Layout Icons
theme = theme_assets.recolor_layout(theme, theme.fg_normal)


return theme
