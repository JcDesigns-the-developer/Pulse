-- Pulse keybindings.
-- Application commands come from the central app registry; compositor actions
-- use the Pulse API so custom configurations do not need to know the loader.

local Pulse = require("pulse")
local apps = Pulse.load("apps")
local mod = "SUPER"

local function command(key, executable, description, options)
    options = options or {}
    options.description = description
    Pulse.command(mod .. " + " .. key, executable, options)
end

command("Return", apps.terminal, "Open terminal")
command("D", apps.launcher, "Open application launcher")
command("E", apps.file_manager, "Open file manager")
command("N", apps.network, "Open Pulse network control")
command("P", apps.settings, "Open Pulse settings")
command("W", apps.wallpaper, "Change Pulse wallpaper")
command("F", "hyprctl dispatch fullscreen", "Toggle fullscreen")
command("Q", "hyprctl dispatch killactive", "Close active window")
command("V", "hyprctl dispatch togglefloating", "Toggle floating")
command("L", apps.lock, "Lock screen")

Pulse.bind(mod .. " + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows" })
Pulse.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
Pulse.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

for i = 1, 10 do
    local key = tostring(i % 10)
    Pulse.bind(mod .. " + " .. key, hl.workspace(i), { description = "Switch to workspace " .. i })
    Pulse.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

Pulse.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
Pulse.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })

Pulse.bind("XF86AudioRaiseVolume", Pulse.exec("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true, description = "Increase volume" })
Pulse.bind("XF86AudioLowerVolume", Pulse.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true, description = "Decrease volume" })
Pulse.bind("XF86AudioMute", Pulse.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, description = "Mute audio" })
Pulse.bind("XF86AudioPlay", Pulse.exec("playerctl play-pause"), { locked = true, description = "Play or pause media" })
Pulse.bind("XF86AudioPrev", Pulse.exec("playerctl previous"), { locked = true, description = "Previous track" })
Pulse.bind("XF86AudioNext", Pulse.exec("playerctl next"), { locked = true, description = "Next track" })

Pulse.bind("Print", Pulse.exec(apps.screenshot), { description = "Take screenshot" })
