-- Conservative rules: only applications that are known to behave like utility
-- windows are forced floating. Everything else remains under user control.

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
