-- Startup is intentionally shell-driven. Lua event handlers must not block.
hl.on("hyprland.start", function()
    hl.exec_cmd("sh -c 'pgrep -x waybar >/dev/null || waybar'")
    hl.exec_cmd("sh -c 'pgrep -x mako >/dev/null || mako'")
    hl.exec_cmd("sh -c 'pgrep -x nm-applet >/dev/null || nm-applet --indicator'")
    hl.exec_cmd("sh -c 'command -v swww-daemon >/dev/null && pgrep -x swww-daemon >/dev/null || true'")
end)
