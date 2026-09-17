-- Pulse Hyprland configuration
-- The entry point stays small: each file below owns one part of the desktop.

require("variables")
require("environment")
require("general")
require("monitors")
require("input")
require("layout")
require("decoration")
require("animations")
require("rules")
require("workspaces")
require("keybinds")
require("startup")

-- Optional machine-local configuration. This file is not managed by Pulse.
local user = io.open(os.getenv("HOME") .. "/.config/hypr/hypr-user.lua", "r")
if user then
    user:close()
    require("hypr-user")
end
