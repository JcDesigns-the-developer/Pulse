-- Session startup.

local home = os.getenv("HOME")
local bin = home .. "/.local/bin/"

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hypridle")
    hl.exec_cmd(bin .. PULSE.wallpaper)
end)
