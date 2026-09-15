-- Pulse Ghost desktop
-- Hyprland 0.55+ Lua entry point.
-- Keep this file intentionally small: modules own individual concerns.

require("pulse.theme")
require("pulse.env")
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

-- Optional per-machine overrides. These files are never required for Pulse
-- to boot, so a fresh installation remains portable.
pcall(require, "custom")
