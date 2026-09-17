-- Conservative application rules.
-- Unknown applications are left completely under normal Hyprland behavior.

hl.window_rule({
    name = "pulse-floating-dialogs",
    match = {
        class = "^(pavucontrol|nm-connection-editor|blueman-manager)$",
    },
    float = true,
})

hl.window_rule({
    name = "pulse-floating-rofi",
    match = {
        class = "^(Rofi)$",
    },
    float = true,
})
