-- Pulse Ghost desktop
-- Simple Hyprland Lua entry point.
-- Each part of the desktop lives in its own file, just like the standard
-- ML4W / KooL-style layouts. Edit the matching module instead of a loader.

require("pulse.theme")
require("pulse.env")
require("pulse.core")
require("pulse.settings")
require("pulse.monitors")
require("pulse.input")
require("pulse.layout")
require("pulse.appearance")
require("pulse.animations")
require("pulse.rules")
require("pulse.workspaces")
require("pulse.binds")
require("pulse.startup")

-- Optional per-machine overrides. Keep personal changes here.
local custom = io.open(os.getenv("HOME") .. "/.config/hypr/custom.lua", "r")
if custom then
    custom:close()
    require("custom")
end
