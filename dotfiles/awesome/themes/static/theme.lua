----------------------------------------------------------------
-- derpyasianpanda's Static Awesome Theme Based on Xresources --
----------------------------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local icon_dir = gfs.get_configuration_dir() .. "icons/"
local default_theme_dir = gfs.get_themes_dir() .. "default/"

local theme = {}

-- {{{ Icons from awesome-copycats
theme.cpu = icon_dir .. "powerarrow/cpu.png"
theme.net = icon_dir .. "powerarrow/net_up.png"
theme.note = icon_dir .. "powerarrow/note.png"
theme.note_on = icon_dir .. "powerarrow/note_on.png"
-- }}}

-- {{{
theme.layout_fairh = default_theme_dir .."layouts/fairhw.png"
theme.layout_fairv = default_theme_dir .. "layouts/fairvw.png"
theme.layout_floating  = default_theme_dir .. "layouts/floatingw.png"
theme.layout_magnifier = default_theme_dir .. "layouts/magnifierw.png"
theme.layout_max = default_theme_dir .. "layouts/maxw.png"
theme.layout_fullscreen = default_theme_dir .. "layouts/fullscreenw.png"
theme.layout_tilebottom = default_theme_dir .. "layouts/tilebottomw.png"
theme.layout_tileleft   = default_theme_dir .. "layouts/tileleftw.png"
theme.layout_tile = default_theme_dir .. "layouts/tilew.png"
theme.layout_tiletop = default_theme_dir .. "layouts/tiletopw.png"
theme.layout_spiral  = default_theme_dir .. "layouts/spiralw.png"
theme.layout_dwindle = default_theme_dir .. "layouts/dwindlew.png"
theme.layout_cornernw = default_theme_dir .. "layouts/cornernww.png"
theme.layout_cornerne = default_theme_dir .. "layouts/cornernew.png"
theme.layout_cornersw = default_theme_dir .. "layouts/cornersww.png"
theme.layout_cornerse = default_theme_dir .. "layouts/cornersew.png"
-- }}}

theme.wallpaper = gfs.get_configuration_dir() .. "themes/static/background.png"

theme.font          = "Monaco 8"

theme.bg_normal     = xrdb.color0 .. "CC"
theme.bg_focus      = xrdb.color1 .. "CC"
theme.bg_urgent     = xrdb.color5 .. "CC"
theme.bg_minimize   = xrdb.color8 .. "CC"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = xrdb.color15
theme.fg_focus      = xrdb.color15
theme.fg_minimize   = xrdb.color8
theme.fg_urgent     = xrdb.color5

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

theme.taglist_bg_occupied = theme.bg_minimize
-- theme.taglist_fg_occupied = xrdb.color0

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus

theme.menu_height = dpi(16)
theme.menu_width  = dpi(100)

theme.systray_icon_spacing = 5

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height * 2, theme.bg_urgent, theme.fg_normal
)

return theme
