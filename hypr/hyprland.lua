-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

package.loaded["default.hypr.autostart"] = true

-- require("default.hypr.omarchy")

require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- App rules
require("hypr.apps.steam")
require("hypr.apps.jetbrains")
require("hypr.apps.localsend")
require("hypr.apps.telegram")
require("hypr.apps.bitwarden")
require("hypr.apps.xwaylandapps")
require("hypr.apps.mpv")

-- Toggle config flags dynamically.
--require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
