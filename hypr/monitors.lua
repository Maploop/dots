local gdk_scale = 1
local qt_scale_factor = 1
local auto_scale_factor = 0
local monitor_scale = 1

hl.env("GDK_SCALE", tostring(gdk_scale))
hl.env("QT_SCALE_FACTOR", tostring(qt_scale_factor))
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", tostring(auto_scale_factor))

hl.monitor({ output = "", mode = "1920x1080@164", position = "auto", scale = monitor_scale })
