-- Pulse keybindings.
-- Application launches use the central app registry. Compositor actions use
-- Hyprland's native Lua dispatchers so the config stays easy to understand.

local apps = require("pulse.apps")
local mod = "SUPER"

local function bind(key, dispatcher, description, flags)
    flags = flags or {}
    flags.description = description
    hl.bind(mod .. " + " .. key, dispatcher, flags)
end

bind("Return", hl.dsp.exec_cmd(apps.terminal), "Open terminal")
bind("D", hl.dsp.exec_cmd(apps.launcher), "Open application launcher")
bind("E", hl.dsp.exec_cmd(apps.file_manager), "Open file manager")
bind("N", hl.dsp.exec_cmd(apps.network), "Open Pulse network control")
bind("P", hl.dsp.exec_cmd(apps.settings), "Open Pulse settings")
bind("W", hl.dsp.exec_cmd(apps.wallpaper), "Change Pulse wallpaper")
bind("F", hl.dsp.window.fullscreen(), "Toggle fullscreen")
bind("Q", hl.dsp.window.close(), "Close active window")
bind("V", hl.dsp.window.float(), "Toggle floating")
bind("L", hl.dsp.exec_cmd(apps.lock), "Lock screen")

bind("Tab", hl.dsp.window.cycle_next(), "Cycle windows")

hl.bind("ALT + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
    description = "Move window",
})

hl.bind("ALT + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
    description = "Resize window",
})

for i = 1, 10 do
    local key = tostring(i % 10)

    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }), {
        description = "Switch to workspace " .. i,
    })

    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }), {
        description = "Move window to workspace " .. i,
    })
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }), {
    description = "Previous workspace",
})

hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }), {
    description = "Next workspace",
})

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), {
    repeating = true,
    locked = true,
    description = "Increase volume",
})

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
    repeating = true,
    locked = true,
    description = "Decrease volume",
})

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
    locked = true,
    description = "Mute audio",
})

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
    description = "Play or pause media",
})

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {
    locked = true,
    description = "Previous track",
})

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {
    locked = true,
    description = "Next track",
})

hl.bind("Print", hl.dsp.exec_cmd(apps.screenshot), {
    description = "Take screenshot",
})
