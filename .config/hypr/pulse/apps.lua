-- Pulse application registry.
-- Keep executable choices in one place so keybinds and startup stay consistent.

return {
    terminal = "kitty",
    launcher = "rofi -show drun",
    file_manager = "kitty --start-as=fullscreen --hold ranger",
    lock = "hyprlock",
    network = "pulse-network",
    settings = "pulse-settings",
    wallpaper = "pulse-wallpaper",
    screenshot = "pulse-screenshot",
}
