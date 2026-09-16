-- Pulse Ghost desktop
-- Hyprland 0.55+ Lua entry point.
-- This is the only compositor entry file; modules own individual concerns.

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

-- Optional per-machine overrides. Pulse itself never requires these to exist.
pcall(require, "custom")
