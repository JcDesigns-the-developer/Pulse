-- Startup is shell-driven. Lua event handlers must not block the compositor.
local function start_once(command, process)
    hl.exec_cmd("sh -c 'pgrep -x " .. process .. " >/dev/null || " .. command .. "'")
end

hl.on("hyprland.start", function()
    start_once("waybar", "waybar")
    start_once("mako", "mako")
    start_once("nm-applet --indicator", "nm-applet")
    start_once("hypridle", "hypridle")
    hl.exec_cmd("pulse-wallpaper >/dev/null 2>&1 || true")
end)
