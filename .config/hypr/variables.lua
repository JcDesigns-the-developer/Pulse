-- User-adjustable Pulse defaults.
-- Change values here before editing the individual Hyprland modules.

PULSE = {
    terminal = "kitty",
    launcher = "rofi -show drun",
    file_manager = "kitty --start-as=fullscreen --hold ranger",
    network = "pulse-network",
    settings = "pulse-settings",
    wallpaper = "pulse-wallpaper",
    lock = "hyprlock",
    screenshot = "pulse-screenshot",

    colors = {
        black = "0a0a0a",
        black_deep = "050505",
        white = "f5f5f5",
        gray = "b8b8b8",
        gray_dark = "242424",
        inactive = "777777aa",
        panel = "090909e6",
    },
}

function pulse_rgb(hex)
    return "rgb(" .. hex .. ")"
end

function pulse_rgba(hex, alpha)
    return "rgba(" .. hex .. alpha .. ")"
end
