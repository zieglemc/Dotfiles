-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Error handling
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
-- }}}

-- ####################### THEME STUFF ######################
-- load colors from xresources
local xrdb = beautiful.xresources.get_current_theme()
-- Make dpi function global
dpi = beautiful.xresources.apply_dpi
-- Make xresources colors global
x = {
   --           xrdb variable      fallback
   background = xrdb.background or "#1D1F28",
   foreground = xrdb.foreground or "#FDFDFD",
   color0     = xrdb.color0     or "#282A36",
   color1     = xrdb.color1     or "#F37F97",
   color2     = xrdb.color2     or "#5ADECD",
   color3     = xrdb.color3     or "#F2A272",
   color4     = xrdb.color4     or "#8897F4",
   color5     = xrdb.color5     or "#C574DD",
   color6     = xrdb.color6     or "#79E6F3",
   color7     = xrdb.color7     or "#FDFDFD",
   color8     = xrdb.color8     or "#414458",
   color9     = xrdb.color9     or "#FF4971",
   color10    = xrdb.color10    or "#18E3C8",
   color11    = xrdb.color11    or "#FF8037",
   color12    = xrdb.color12    or "#556FFF",
   color13    = xrdb.color13    or "#B043D1",
   color14    = xrdb.color14    or "#3FDCEE",
   color15    = xrdb.color15    or "#BEBEC1",
}
-- load my theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/crap-theme/theme.lua")

-- setting default programs
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "emacs"
terminal = "urxvtc"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.floating,
   awful.layout.suit.tile.left,
   -- awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   -- awful.layout.suit.fair,
   -- awful.layout.suit.fair.horizontal,
   -- awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   -- awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier,
   awful.layout.suit.corner.nw,
   awful.layout.suit.corner.ne,
   awful.layout.suit.corner.sw,
   awful.layout.suit.corner.se,
}
-- }}}


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

function reset_wallpaper()
   awful.screen.connect_for_each_screen(function(s)
         -- Wallpaper
         set_wallpaper(s)
                                        end
   )
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local widgets = require("widgets")

awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      set_wallpaper(s)

      -- Each screen has its own tag table.
      awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contains an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(gears.table.join(
                               awful.button({ }, 1, function () awful.layout.inc( 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(-1) end),
                               awful.button({ }, 4, function () awful.layout.inc( 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, widgets.taglist_buttons)

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, widgets.tasklist_buttons)

      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s })

      -- Add widgets to the wibox
      s.mywibox:setup {
         layout = wibox.layout.align.horizontal,
         { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            widgets.mylauncher,
            s.mytaglist,
            s.mypromptbox,
            widgets.separator,
         },
         s.mytasklist, -- Middle widget
         { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            widgets.mykeyboardlayout,
            widgets.separator,
            widgets.mytextclock,
            s.mylayoutbox,
         },
      }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
                awful.button({ }, 1, function () widgets.mymainmenu:hide() end),
                awful.button({ }, 3, function () widgets.mymainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


local keys = require("keybindings")


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    raise = true,
                    keys = keys.clientkeys,
                    buttons = clientbuttons,
                    size_hints_honor = false, -- Remove gaps between terminals
                    screen = awful.screen.preferred,
                    callback = awful.client.setslave,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
   },

   -- Floating clients.
   { rule_any = {
        instance = {
           "DTA",  -- Firefox addon DownThemAll.
           "copyq",  -- Includes session name in class.
        },
        class = {
           "Arandr",
           "Gpick",
           "Kruler",
           "MessageWin",  -- kalarm.
           "Sxiv",
           "Wpa_gui",
           "pinentry",
           "veromix",
           "xtightvncviewer"},

        name = {
           "Event Tester",  -- xev.
        },
        role = {
           "AlarmWindow",  -- Thunderbird's calendar.
           "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
   }, properties = { floating = true }},

   -- Add titlebars to normal clients and dialogs
   { rule_any = {type = { "normal", "dialog" } },
     properties = { titlebars_enabled = true }
   },

   -- Set Firefox to always map on the tag named "2" on screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { screen = 1, tag = "2" } },


}
-- }}}

-- {{{ Signals


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
                         -- Set the windows at the slave,
                         -- i.e. put it at the end of others instead of setting it master.
                         -- if not awesome.startup then awful.client.setslave(c) end

                         if awesome.startup and
                            not c.size_hints.user_position
                         and not c.size_hints.program_position then
                            -- Prevent clients from being unreachable after screen count changes.
                            awful.placement.no_offscreen(c)
                         end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
                         -- buttons for the titlebar
                         local buttons = gears.table.join(
                            awful.button({ }, 1, function()
                                  client.focus = c
                                  c:raise()
                                  awful.mouse.client.move(c)
                            end),
                            awful.button({ }, 3, function()
                                  client.focus = c
                                  c:raise()
                                  awful.mouse.client.resize(c)
                            end)
                         )

                         awful.titlebar(c) : setup {
                            { -- Left
                               awful.titlebar.widget.iconwidget(c),
                               buttons = buttons,
                               layout  = wibox.layout.fixed.horizontal
                            },
                            { -- Middle
                               { -- Title
                                  align  = "center",
                                  widget = awful.titlebar.widget.titlewidget(c)
                               },
                               buttons = buttons,
                               layout  = wibox.layout.flex.horizontal
                            },
                            { -- Right
                               awful.titlebar.widget.floatingbutton (c),
                               awful.titlebar.widget.stickybutton   (c),
                               -- awful.titlebar.widget.ontopbutton    (c),
                               awful.titlebar.widget.maximizedbutton(c),
                               awful.titlebar.widget.closebutton    (c),
                               layout = wibox.layout.fixed.horizontal()
                            },
                            layout = wibox.layout.align.horizontal
                                                   }
                         -- Hide the menubar if we are not floating
                         -- local l = awful.layout.get(c.screen)
                         -- if not (l.name == "floating" or c.floating) then
                         --     awful.titlebar.hide(c)
                         -- end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                            client.focus = c
                         end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
   screen[s]:connect_signal("arrange", function ()
                               local clients = awful.client.visible(s)
                               local layout = awful.layout.getname(awful.layout.get(s))

                               for _, c in pairs(clients) do
                                  -- No borders with only one humanly visible client
                                  if c.maximized then
                                     -- NOTE: also handled in focus, but that does not cover maximizing from a
                                     -- tiled state (when the client had focus).
                                     c.border_width = 0
                                  elseif c.floating or layout == "floating" then
                                     c.border_width = beautiful.border_width
                                  elseif layout == "max" or layout == "fullscreen" then
                                     c.border_width = 0
                                  else
                                     local tiled = awful.client.tiled(c.screen)
                                     if #tiled == 1 then -- and c == tiled[1] then
                                        tiled[1].border_width = 0
                                        -- if layout ~= "max" and layout ~= "fullscreen" then
                                        -- XXX: SLOW!
                                        -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
                                        -- end
                                     else
                                        c.border_width = beautiful.border_width
                                     end
                                  end
                               end
                           end)
end

-- }}}

--client.connect_signal("property::floating", function (c)
--    if c.floating then
--        awful.titlebar.show(c)
--    else
--        awful.titlebar.hide(c)
--    end
--end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
