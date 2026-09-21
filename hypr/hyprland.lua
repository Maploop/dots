-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Don't run Omarchy's default autostart -- it launches the Quickshell shell.
-- Pre-seeding package.loaded makes omarchy.lua's require() of it a no-op, so
-- every OTHER default (envs, looknfeel, input, windows, theme) still loads and
-- still tracks package updates. Replacement autostart lives in hypr/autostart.lua.
package.loaded["default.hypr.autostart"] = true

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
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

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
