-- Programs started with the Hyprland session.
-- hyprland.start is emitted once when the compositor starts.

local apps = require("pulse.apps")

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hypridle")
    hl.exec_cmd(apps.wallpaper)
end)
